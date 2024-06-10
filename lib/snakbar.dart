import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String errorText) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorText),
    ),
  );
}
