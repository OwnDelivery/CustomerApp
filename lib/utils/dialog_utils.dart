import 'package:flutter/material.dart';

class DialogUtils {
  static void showErrorDialog(
      {required BuildContext context,
      required String? errorMessage,
      required VoidCallback onClose}) {
    AlertDialog alert = AlertDialog(
      content: Text(errorMessage ?? "Something went wrong. Please try again"),
      actions: [
        TextButton(
          child: const Text("Dismiss"),
          onPressed: () {
            onClose();
            Navigator.pop(context);
          },
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
