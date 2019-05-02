import 'package:flutter/material.dart';

class ErrorHandler{
  static handle(int code){
    switch(code){
      case 401:{

        break;
      }
    }
  }

  static Future<void> AlertDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Not in stock'),
          content: const Text('This item is no longer available'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}