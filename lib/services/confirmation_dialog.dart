import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfirmationDialogService {
  static Future<void> openConfirmation(BuildContext context, String title,
      String? message, List<Widget> actions) async {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: message != null ? Text(message) : null,
      actions: actions,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
