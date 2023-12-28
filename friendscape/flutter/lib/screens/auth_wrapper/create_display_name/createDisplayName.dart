import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friendscape/constants/themeConstants.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:friendscape/services/alertService.dart';
import 'package:friendscape/services/authService.dart';

class CreateDisplayName extends StatefulWidget {
  // initializing with user
  final User user;

  CreateDisplayName(this.user);

  @override
  _CreateDisplayNameState createState() => _CreateDisplayNameState();
}

class _CreateDisplayNameState extends State<CreateDisplayName> {
  /// SERVICES
  final AuthService authService = AuthService();

  /// UI PROPERTIES
  final double horizontalPadding = 80;
  final double paddingHeight = 15;
  final double buttonWidth = 200;
  final double buttonHeight = 50;

  /// STATE PROPERTIES
  String displayName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.backgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // username text field
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
              onChanged: (s) => setState(() => displayName = s),
            ),

            SizedBox(height: paddingHeight),

            // submit button
            ElevatedButton(
              child: Text('Submit'),
              style: buttonStyle(),
              onPressed: () async {
                RequestResult result =
                    await authService.postUser(widget.user, displayName);
                if (result.error) {
                  AlertService.errorAlert(result.data, context);
                } else {
                  widget.user.updateDisplayName(displayName);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // submit button style
  ButtonStyle buttonStyle() {
    return ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonHeight / 2))),
        backgroundColor: MaterialStateProperty.all(ThemeConstants.buttonColor));
  }
}
