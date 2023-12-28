import 'package:flutter/material.dart';
import 'package:friendscape/constants/themeConstants.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/services/alertService.dart';
import 'package:friendscape/services/authService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /// SERVICES
  final AuthService authService = AuthService();

  /// UI PROPERTIES
  final double horizontalPadding = 80;
  final double paddingHeight = 15;
  final double buttonWidth = 200;
  final double buttonHeight = 50;

  /// STATE PROPERTIES
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // email text field
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
            onChanged: (s) => setState(() => email = s),
          ),

          SizedBox(height: paddingHeight),

          // password text field
          TextField(
            decoration: InputDecoration(labelText: 'Password'),
            onChanged: (s) => setState(() => password = s),
          ),

          SizedBox(height: paddingHeight),

          // login button
          ElevatedButton(
            child: Text('Login'),
            style: buttonStyle(),
            onPressed: () async {
              RequestResult result = await authService.login(email, password);
              if (result.error) {
                AlertService.errorAlert(result.data, context);
              }
            },
          )
        ],
      ),
    );
  }

  // styling for login button
  ButtonStyle buttonStyle() {
    return ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonHeight / 2))),
        backgroundColor: MaterialStateProperty.all(ThemeConstants.buttonColor));
  }
}
