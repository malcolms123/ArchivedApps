import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:friendscape/screens/mainWrapper.dart';
import 'package:friendscape/services/authService.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Friendscape());
}

class Friendscape extends StatelessWidget {

  /// TO BE IMPLEMENTED FOR ASYNC STARTUP
  Future startUp() async {
    return true;
  }

  /// SERVICES
  final AuthService authService = AuthService();


  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friendscape',
      home: FutureBuilder(
        future: startUp(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return StreamProvider<User?>.value(
              value: authService.userStream,
              initialData: null,
              child: MainWrapper(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}