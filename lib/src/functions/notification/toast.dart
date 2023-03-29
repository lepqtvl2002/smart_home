import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast(BuildContext context) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text('Added to favorite'),
      action: SnackBarAction(
          label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

void showError(BuildContext context, String title,
    [String? description, Duration? duration]) {
  duration ??= const Duration(seconds: 5);
  toastification.showError(
    context: context,
    title: title,
    description: description,
    autoCloseDuration: duration,
    backgroundColor: Colors.pink.shade600,
  );
}

void showSuccess(BuildContext context, String title,
    [String? description, Duration? duration]) {
  duration ??= const Duration(seconds: 5);
  toastification.showSuccess(
    context: context,
    title: title,
    description: description,
    autoCloseDuration: duration,
  );
}

void showWarning(BuildContext context, String title,
    [String? description, Duration? duration]) {
  duration ??= const Duration(seconds: 5);
  toastification.showWarning(
    context: context,
    title: title,
    description: description,
    autoCloseDuration: duration,
  );
}

void showInfo(BuildContext context, String title,
    [String? description, Duration? duration]) {
  duration ??= const Duration(seconds: 5);
  toastification.showInfo(
    context: context,
    title: title,
    description: description,
    autoCloseDuration: duration,
  );
}
