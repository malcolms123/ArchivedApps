import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendscape/models/account.dart';
import 'package:uuid/uuid.dart';

class Post {
  /// IMPORTANT
  // needs to stay consistent with firestore as well as cloud functions
  // do not edit without ensuring consistent

  // properties
  late String posterUid;
  late String posterUsername;
  late String postUid;
  late String body;
  late DateTime postTime;

  // first time post creation
  Post(Account posterAccount, this.body) {
    this.posterUid = posterAccount.uid;
    this.posterUsername = posterAccount.username;
    this.postUid = Uuid().v4();
    this.postTime = DateTime.now();
  }

  // initializing with firestore doc object
  Post.fromDoc(DocumentSnapshot doc) {
    this.posterUid = doc.get('posterUid');
    this.posterUsername = doc.get('posterUsername');
    this.postUid = doc.get('postUid');
    this.body = doc.get('body');
    Timestamp ts = doc.get('postTime');
    this.postTime =
        DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);
  }

  // format for posting to firestore
  Map<String, dynamic> format() {
    return {
      'posterUid': this.posterUid,
      'posterUsername': this.posterUsername,
      'postUid': this.postUid,
      'body': this.body,
      'postTime': this.postTime
    };
  }
}
