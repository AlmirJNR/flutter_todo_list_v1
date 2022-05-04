import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';
import 'package:flutter_todo_list_v1/widgets/todo_list_item.dart';

class ToDoListWidget extends StatelessWidget {
  const ToDoListWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ToDosController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.todosNotifierFlag,
      builder: (context, bool todosNotifier, child) {
        return Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.35)
                  : Colors.white.withOpacity(0.35),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListView.separated(
              itemCount: controller.toDos.length,
              itemBuilder: (BuildContext context, int index) {
                return ToDoListItemWidget(
                  index: index,
                  controller: controller,
                  todo: controller.toDos[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(height: 0, thickness: 1),
            ),
          ),
        );
      },
    );
  }
}
