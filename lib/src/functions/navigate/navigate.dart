import 'package:flutter/cupertino.dart';

// Navigate page function
void navigatePage(BuildContext context, String path) {
  Navigator.pushReplacementNamed(context, path);
}

// Close modal
void closeModal(BuildContext context) {
  Navigator.pop(context);
}