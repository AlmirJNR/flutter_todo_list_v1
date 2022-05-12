import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/widgets/update_todo_modal.dart';
import 'package:intl/intl.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';

import '../home/todo_model.dart';
import 'remove_todo_snackbar.dart';

class ToDoListItemWidget extends StatelessWidget {
  const ToDoListItemWidget({
    Key? key,
    required this.index,
    required this.controller,
    required this.todo,
  }) : super(key: key);

  final int index;
  final ToDosController controller;
  final ToDo todo;

  void _buildDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => UpdateToDoModalWidget(
        context,
        todo: todo,
        controller: controller.updateToDoInputController,
        focusNode: controller.updateToDosInputFocusNode,
        onAccepted: () {
          controller.updateToDo(todo);
          Navigator.of(context).pop();
        },
      ).alertDialog,
      barrierDismissible: false,
    );
  }

  void _buildSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      RemoveToDoSnackbarWidget(
        context,
        text: 'You have removed ${controller.removedToDo?.title}',
        onPressed: () => controller.undoRemoveToDo(),
      ).snackBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.showUpdateToDoDialog(
        todo: todo,
        showDialog: () => _buildDialog(context),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy - HH:mm').format(todo.date ?? DateTime.now()),
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      todo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () => controller.removeToDo(
                  index: index,
                  todo: todo,
                  showSnackbar: () => _buildSnackbar(context),
                ),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.only()),
                ),
                child: const Icon(Icons.remove),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
