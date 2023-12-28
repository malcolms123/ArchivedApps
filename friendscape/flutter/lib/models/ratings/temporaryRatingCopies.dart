import 'package:cloud_firestore/cloud_firestore.dart';

import '../account.dart';

/// TEMPORARY
// these are to distinguish streams to solve to AllRatings stream bug


class RatingIn {
  late String posterUid;
  late String posterUsername;
  late String recipientUid;
  late String recipientUsername;
  late double value;

  RatingIn(Account posterAccount, Account recipientAccount, this.value) {
    this.posterUid = posterAccount.uid;
    this.posterUsername = posterAccount.username;
    this.recipientUid = recipientAccount.uid;
    this.recipientUsername = recipientAccount.username;
  }

  // initializing from firestore doc object
  RatingIn.fromDoc(DocumentSnapshot doc) {
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
}

class RatingOut {
  // properties
  late String posterUid;
  late String posterUsername;
  late String recipientUid;
  late String recipientUsername;
  late double value;

  RatingOut(Account posterAccount, Account recipientAccount, this.value) {
    this.posterUid = posterAccount.uid;
    this.posterUsername = posterAccount.username;
    this.recipientUid = recipientAccount.uid;
    this.recipientUsername = recipientAccount.username;
  }

  // initializing from firestore doc object
  RatingOut.fromDoc(DocumentSnapshot doc) {
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
}