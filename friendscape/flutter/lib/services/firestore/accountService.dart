import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:friendscape/constants/firestoreConstants.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/models/requestResult.dart';

class AccountService {

  CollectionReference accountsCollection = FirebaseFirestore.instance
      .collection(FirestoreConstants.accountsCollection);

  // pull account using uid
  // possibly change to cloud function for security purposes
  Future<RequestResult> pullAccount(String uid) async {
    try {
      DocumentSnapshot doc = await accountsCollection.doc(uid).get();
      Account account = Account.fromDoc(doc);
      return RequestResult(false, account);
    } catch(e) {
      return RequestResult(true, e.toString());
    }
  }

}