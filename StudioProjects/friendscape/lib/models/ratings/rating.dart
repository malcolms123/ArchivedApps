import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendscape/models/ratings/temporaryRatingCopies.dart';

import '../account.dart';

class Rating {
  /// IMPORTANT
  // needs to stay consistent with firestore as well as cloud functions
  // do not edit without ensuring consistent

  /// NOTES
  // ratings posted to ratingsIn and ratingsOut collections
  // document id is the uid of the non-collection owner
  // ratingsIn -> id = posterUid
  // ratingsOut -> id = recipientUid

  // properties
  late String posterUid;
  late String posterUsername;
  late String recipientUid;
  late String recipientUsername;
  late double value;

  Rating(Account posterAccount, Account recipientAccount, this.value) {
    this.posterUid = posterAccount.uid;
    this.posterUsername = posterAccount.username;
    this.recipientUid = recipientAccount.uid;
    this.recipientUsername = recipientAccount.username;
  }

  // initializing from firestore doc object
  Rating.fromDoc(DocumentSnapshot doc) {
    this.posterUid = doc.get('posterUid');
    this.posterUsername = doc.get('posterUsername');
    this.recipientUid = doc.get('recipientUid');
    this.recipientUsername = doc.get('recipientUsername');
    this.value = doc.get('value').toDouble();
  }

  // format for posting to firestore
  Map<String, dynamic> format() {
    return {
      'posterUid': this.posterUid,
      'posterUsername': this.posterUsername,
      'recipientUid': this.recipientUid,
      'recipientUsername': this.recipientUsername,
      'value': this.value
    };
  }

  /// TEMPORARY CONSTRUCTORS FOR BUG WORKAROUND
  Rating.fromRatingIn(RatingIn ratingIn) {
    this.posterUid = ratingIn.posterUid;
    this.posterUsername = ratingIn.posterUsername;
    this.recipientUid = ratingIn.recipientUid;
    this.recipientUsername = ratingIn.recipientUsername;
    this.value = ratingIn.value;
  }

  Rating.fromRatingOut(RatingOut ratingOut) {
    this.posterUid = ratingOut.posterUid;
    this.posterUsername = ratingOut.posterUsername;
    this.recipientUid = ratingOut.recipientUid;
    this.recipientUsername = ratingOut.recipientUsername;
    this.value = ratingOut.value;
  }
}
