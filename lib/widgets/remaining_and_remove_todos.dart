import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';
import 'package:provider/provider.dart';

class RemainingAndClearToDosWidget extends StatelessWidget {
  const RemainingAndClearToDosWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ToDosController controller = context.watch<ToDosController>();

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
  }
}
