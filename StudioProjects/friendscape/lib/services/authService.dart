import 'package:firebase_auth/firebase_auth.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/models/account.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AuthService {
  FirebaseAuth instance = FirebaseAuth.instance;

  /// USER CREATION AND SIGN IN FUNCTIONS
  // login method
  Future<RequestResult> login(String email, String password) async {
    try {
      await instance.signInWithEmailAndPassword(
          email: email, password: password);
      return RequestResult(false, null);
    } catch (e) {
      return RequestResult(true, e.toString());
    }
  }

  // account creation method
  Future<RequestResult> createAccount(String email, String password) async {
    try {
      await instance.createUserWithEmailAndPassword(
          email: email, password: password);
      return RequestResult(false, null);
    } catch (e) {
      return RequestResult(true, e.toString());
    }
  }

  // logout method
  Future<RequestResult> signOut() async {
    try {
      await instance.signOut();
      return RequestResult(false, null);
    } catch(e) {
      return RequestResult(true, e.toString());
    }
  }

  /// STREAMS
  Stream<User?>? get userStream {
    return instance.userChanges();
  }

  /// CLOUD FUNCTIONS
  Future<RequestResult> postUser(User user, String displayName) async {
    try {
      Account account = Account(user, displayName);
      HttpsCallableResult result = await FirebaseFunctions.instance
          .httpsCallable('postAccount')
          .call(account.format());
      return RequestResult.fromMap(result.data);
    } catch (e) {
      print(e.toString());
      return RequestResult(
          true, 'Something went wrong, check your connection and try again.');
    }
  }
}
