import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Account {

  /// IMPORTANT
  // needs to stay consistent with firestore as well as cloud functions
  // do not edit without ensuring consistent

  // properties
  late String uid;
  late String email;
  late String username;
  late String profilePicture;

  // initializing with firebase user object
  Account(User user, String displayName) {
    this.uid = user.uid;
    this.email = user.email!;
    this.username = displayName;
    this.profilePicture = 'default/defaultProfilePicture.jpeg';
  }

  // initializing with firestore doc object
  Account.fromDoc(DocumentSnapshot doc) {
    this.uid = doc.get('uid');
    this.email = doc.get('email');
    this.username = doc.get('username');
    this.profilePicture = doc.get('profilePicture');
  }

  // format for posting to firestore
  Map<String, dynamic> format() {
    return {
      'uid': this.uid,
      'email': this.email,
      'username': this.username,
      'profilePicture': this.profilePicture
    };
  }
}
