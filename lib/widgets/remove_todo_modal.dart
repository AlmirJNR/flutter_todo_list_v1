import 'package:flutter/material.dart';

class RemoveToDoDialogWidget {
  RemoveToDoDialogWidget(
    BuildContext context, {
    required String title,
    required String content,
    void Function()? onDismissed,
    required void Function() onAccepted,
  }) {
    onDismissed ??= Navigator.of(context).pop;
    
    _alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onDismissed,
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onAccepted,
          child: const Text('Clean all'),
        ),
      ],
    );
  }

  late final AlertDialog _alertDialog;

  AlertDialog get alertDialog => _alertDialog;
}
