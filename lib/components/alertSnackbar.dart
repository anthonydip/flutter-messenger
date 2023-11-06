import 'package:flutter/material.dart';

void alertSnackbarMessage(String message, ScaffoldMessengerState scaffold) {
  scaffold.showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
      width: 280.0,
      padding: const EdgeInsets.all(8.0),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // backgroundColor: Colors.white,
    ),
  );
}