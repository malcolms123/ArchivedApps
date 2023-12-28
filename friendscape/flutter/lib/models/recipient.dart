class Recipient {
  /// IMPORTANT
  // needs to stay consistent with firestore as well as cloud functions
  // do not edit without ensuring consistent

  final String uid;
  final String username;

  Recipient(this.uid, this.username);

  // format for posting to firestore
  Map<String, dynamic> format() {
    return {'uid': this.uid, 'username': this.username};
  }
}
