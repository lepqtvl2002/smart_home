import 'package:flutter/material.dart';

void showAlert(Text title, Text content, List<Widget> actions, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    },
  );
}