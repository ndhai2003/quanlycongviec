import 'package:QLCVTB/src/resources/screens/home_page.dart';
import 'package:flutter/material.dart';

import '../screens/login_page.dart';

class MsgDialog {
  static void showMsgDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(msg),
            actions: [
              new ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(MsgDialog);
                },
              ),
            ],
          ),
    );
  }
  static void showCustomDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage()));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  static void showCustomDialogChangInfo(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage()));
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showCustomDialogThime(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                  Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
