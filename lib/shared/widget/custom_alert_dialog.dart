import 'package:flutter/material.dart';
import 'package:task_management/shared/constants/string_const.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirmed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.onConfirmed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirmed != null) {
              onConfirmed!();
            }
          },
          child: const Text(StringConstant.ok),
        ),
      ],
    );
  }

  static void show(BuildContext context, {required String title, required String message, VoidCallback? onConfirmed}) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          title: title,
          message: message,
          onConfirmed: onConfirmed,
        );
      },
    );
  }
}

