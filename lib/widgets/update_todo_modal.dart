import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todo_model.dart';
class UpdateToDoModalWidget {
  UpdateToDoModalWidget(
    BuildContext context, {
    required ToDo todo,
    required TextEditingController controller,
    required FocusNode focusNode,

    required void Function() onAccepted,
  }) {
    _alertDialog = AlertDialog(
      title: const Text('Update your to-do'),
      content: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text,
        maxLength: 50,
      ),
      actions: [
        TextButton(
          onPressed: () {
            focusNode.unfocus();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: onAccepted,
          child: const Text('Update'),
        ),
      ],
    );
  }

  late final AlertDialog _alertDialog;

  AlertDialog get alertDialog => _alertDialog;
}
