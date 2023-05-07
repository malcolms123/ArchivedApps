import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendscape/models/account.dart';
import 'package:uuid/uuid.dart';

class Chat {
  /// IMPORTANT
  // needs to stay consistent with firestore as well as cloud functions
  // do not edit without ensuring consistent

  // properties
  late String posterUid;
  late String posterUsername;
  late String body;
  late String chatUid;
  late DateTime postTime;

  Chat(Account posterAccount, this.body) {
    this.posterUid = posterAccount.uid;
    this.posterUsername = posterAccount.username;
    this.chatUid = Uuid().v4();
    this.postTime = DateTime.now();
  }

  // initializing from firestore doc object
  Chat.fromDoc(DocumentSnapshot doc) {
    this.posterUid = doc.get('posterUid');
    this.posterUsername = doc.get('posterUsername');
    this.body = doc.get('body');
    this.chatUid = doc.get('chatUid');
    Timestamp ts = doc.get('postTime');
    this.postTime =
        DateTime.fromMicrosecondsSinceEpoch(ts.microsecondsSinceEpoch);
  }

  // format for posting to firestore
  Map<String, dynamic> format() {
    return {
      'posterUid': this.posterUid,
      'posterUsername': this.posterUsername,
      'body': this.body,
      'chatUid': this.chatUid,
      'postTime': this.postTime
    };
  }
}
