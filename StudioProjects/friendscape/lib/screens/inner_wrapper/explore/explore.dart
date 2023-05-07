import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:friendscape/constants/firestoreConstants.dart';
import 'package:friendscape/models/account.dart';
import 'package:friendscape/screens/inner_wrapper/view_profile/viewProfile.dart';

class Explore extends StatelessWidget {
  final Account userAccount;

  /// ALL OF THIS IS TEMPORARY
  /// ALL OF THIS IS TEMPORARY
  /// ALL OF THIS IS TEMPORARY

  Explore(this.userAccount);

  Future<List<Account>> getAccounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(FirestoreConstants.accountsCollection)
        .limit(20)
        .get();
    return snapshot.docs
        .map((doc) => Account.fromDoc(doc))
        .where((account) => account.uid != userAccount.uid)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAccounts(),
      builder: (BuildContext context, AsyncSnapshot<List<Account>> snapshot) {
        if (snapshot.hasData) {
          return Container(
              alignment: Alignment.center,
              child: ListView(
                  children: snapshot.data!
                      .map((account) => ListTile(
                          title: Text(account.username),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewProfile(userAccount, account)));
                          }))
                      .toList()));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
