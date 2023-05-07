import 'package:flutter/material.dart';
import 'package:friendscape/constants/themeConstants.dart';
import 'package:friendscape/screens/auth_wrapper/auth_menu/register/register.dart';
import 'login/login.dart';

class AuthMenu extends StatefulWidget {
  @override
  _AuthMenuState createState() => _AuthMenuState();
}

class _AuthMenuState extends State<AuthMenu> {
  /// UI PROPERTIES
  final double paddingHeight = 15;
  final double buttonWidth = 200;
  final double buttonHeight = 50;
  final double backPaddingTop = 40;
  final double backPaddingLeft = 10;
  final double backSize = 40;

  /// STATE PROPERTIES
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ThemeConstants.backgroundColor,
        body: Stack(children: stackWidgets()));
  }

  // styling buttons
  ButtonStyle buttonStyle() {
    return ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(buttonWidth, buttonHeight)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonHeight / 2))),
        backgroundColor: MaterialStateProperty.all(ThemeConstants.buttonColor));
  }

  // populate stack with widgets
  List<Widget> stackWidgets() {
    // initial widget list with back button widget
    List<Widget> widgets = [
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: backPaddingLeft, top: backPaddingTop),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          iconSize: backSize,
          onPressed: () => setState(() => index = 0),
        ),
      )
    ];

    // which widget to add logic
    if (index == 1) {
      widgets.add(Login());
    } else if (index == 2) {
      widgets.add(Register());
    } else {
      // returning auth menu if neither button selected
      return [
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // login button
              ElevatedButton(
                  child: Text('Login'),
                  style: buttonStyle(),
                  onPressed: () => setState(() => index = 1)),

              SizedBox(height: paddingHeight),

              // create account button
              ElevatedButton(
                child: Text('Create Account'),
                style: buttonStyle(),
                onPressed: () => setState(() => index = 2),
              )
            ],
          ),
        )
      ];
    }
    return widgets;
  }
}
