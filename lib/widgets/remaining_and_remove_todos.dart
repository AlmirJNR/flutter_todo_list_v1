import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';

class RemainingAndClearToDosWidget extends StatelessWidget {
  const RemainingAndClearToDosWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ToDosController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.todosNotifierFlag,
      builder: (context, bool todosNotifier, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('You have ${controller.toDos.length} to-dos left'),
            ElevatedButton(
              onPressed: controller.toDos.isNotEmpty ? () => controller.showRemoveAllToDosDialog(context) : null,
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0)),
              ),
              child: const Text('Remove all'),
            ),
          ],
        );
      },
    );
  }
}
