import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendscape/constants/firestoreConstants.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/post.dart';
import 'package:friendscape/models/recipient.dart';
import 'package:friendscape/models/requestResult.dart';

class PostService {
  final Account userAccount;
  late CollectionReference postsOutCollection;
  late CollectionReference postsInCollection;

  PostService(this.userAccount) {
    DocumentReference userDoc = FirebaseFirestore.instance
        .collection(FirestoreConstants.accountsCollection)
        .doc(userAccount.uid);
    this.postsOutCollection =
        userDoc.collection(FirestoreConstants.postsOutCollection);
    this.postsInCollection =
        userDoc.collection(FirestoreConstants.postsInCollection);
  }

  /// POSTING TO FIRESTORE
  Future<RequestResult> postPost(Post post, List<Recipient> recipients) async {
    try {
      DocumentReference postDoc = postsOutCollection.doc(post.postUid);
      await postDoc.set(post.format());
      for (Recipient recipient in recipients) {
        await postDoc
            .collection(FirestoreConstants.recipientsCollection)
            .doc(recipient.uid)
            .set(recipient.format());
      }
      return RequestResult(false, null);
    } catch (e) {
      return RequestResult(true, e.toString());
    }
  }

  /// PULLING FROM FIRESTORE
  Future<RequestResult> pullPosts() async {
    try {
      List<Post> posts =
          postListFromSnapshot(await postsInCollection.limit(20).get());
      return RequestResult(false, posts);
    } catch (e) {
      return RequestResult(true, e.toString());
    }
  }

  /// STREAMS
  Stream<List<Post>> get postsOut {
    return postsOutCollection.snapshots().map(postListFromSnapshot);
  }

  List<Post> postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
  }
}
