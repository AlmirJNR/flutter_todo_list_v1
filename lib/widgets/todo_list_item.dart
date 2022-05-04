import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';

import '../home/todo_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => controller.showUpdateToDoDialog(context, todo),
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
                onPressed: () => controller.removeToDo(context, index: index, todo: todo),
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
