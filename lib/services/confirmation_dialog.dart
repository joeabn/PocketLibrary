import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ConfirmationDialogService {
  static void openConfirmation(BuildContext context, String title,
      String? message, List<Widget> actions) {
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: message != null ? Text(message) : null,
      actions: actions,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
