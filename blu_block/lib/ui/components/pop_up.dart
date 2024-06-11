import 'package:flutter/material.dart';

showMessage(BuildContext context, String message, String title, [bool allowClose = true]){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          if(allowClose)
          TextButton(
            child: Text('Schließen'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}