// imports
import functions = require("firebase-functions");
import admin = require("firebase-admin");

// initializing firestore handling
admin.initializeApp();

// top level collection strings
const accountsCollection = "accounts";
const postsCollection = "posts";

// nested collection strings
const ratingsInCollection = "ratingsIn";
const ratingsOutCollection = "ratingsOut";
const postsOutCollection = "postsOut";
const postsInCollection = "postsIn";
const recipientsCollection = "recipients";

// collection references
const accountsReference = admin.firestore().collection(accountsCollection);
const postsReference = admin.firestore().collection(postsCollection);

// FUNCTION FOR FIRST TIME ACCOUNTS TO DATABASE
// needs more rules for what usernames are allowed
exports.postAccount = functions.https.onCall(async (account, context) => {
  try {
    if (!context.auth) {
      return {"error": true, "data": "Not signed in."};
    } else {
      if (account.username.length < 5) {
        return {"error": true,
          "data": "Username must be at least 5 characters."};
      } else if (account.username.length > 20) {
        return {"error": true,
          "data": "Username length cannot exceed 20 characters."};
      }
      const snapshot = await accountsReference
          .where("username", "==", account.username).get();
      if (snapshot.empty) {
        await accountsReference.doc(account.uid).set(account);
        return {"error": false, "data": null};
      } else {
        return {"error": true, "data": "Username unavailable."};
      }
    }
  } catch {
    return {"error": true, "data": "Something went wrong."};
  }
});

// send rating to other users
// probably needs better error handling
// possibly add notifications
exports.sendRating = functions.firestore.document(accountsCollection +
    "/{posterUid}/" + ratingsOutCollection + "/{recipientUid}").onWrite(
    (change, context) => {
      const rating = change.after.data();
      if (rating) {
        accountsReference.doc(context.params.recipientUid)
            .collection(ratingsInCollection).doc(context.params.posterUid)
            .set(rating);
      }
    }
);

// send posts to other users and post collection
exports.sendPost = functions.firestore.document(accountsCollection +
    "/{posterUid}/" + postsOutCollection + "/{postUid}").onWrite(
    async (change, context) => {
      const post = change.after.data();
      if (post) {
        await postsReference.doc(context.params.postUid).set(post);
        const recipients = await accountsReference.doc(context.params.posterUid)
            .collection(postsOutCollection).doc(context.params.postUid)
            .collection(recipientsCollection).get();
        for (const recipient of recipients.docs) {
          const recipientUid = recipient.get("uid");
          const returnedRating = await accountsReference.doc(recipientUid)
              .collection(ratingsOutCollection)
              .where("recipientUid", "==", context.params.posterUid).get();
          if (!returnedRating.empty) {
            postsReference.doc(context.params.postUid)
                .collection(recipientsCollection).doc(recipientUid)
                .set(recipient.data());
            accountsReference.doc(recipientUid).collection(postsInCollection)
                .doc(context.params.postUid).set(post);
          }
        }
      }
    }
);
