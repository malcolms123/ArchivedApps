import 'package:flutter/material.dart';

class AlertService {
  // basic error alert
  static void errorAlert(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Error'),
              content: SingleChildScrollView(child: Text(message)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Ok'),
                ),
              ]);
        });
  }
}
