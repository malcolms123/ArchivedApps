import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendscape/screens/auth_wrapper/auth_menu/authMenu.dart';
import 'package:friendscape/screens/auth_wrapper/create_display_name/createDisplayName.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    User? user = Provider.of<User?>(context);

    if (user == null) {
      return AuthMenu();
    } else if (user.displayName == null) {
      return CreateDisplayName(user);
    } else {
      // this should never return due to MainWrapper logic
      return Container();
    }

  }
}
