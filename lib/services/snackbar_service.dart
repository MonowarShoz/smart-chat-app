import 'package:flutter/material.dart';

class SnackBarService {
  BuildContext ctx;

  static SnackBarService instance = SnackBarService();

  SnackBarService() {}

  set buildSnackbarContext(BuildContext context) {
    ctx = context;
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

}
