import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';
import 'package:flutter_todo_list_v1/widgets/add_todo.dart';
import 'package:flutter_todo_list_v1/widgets/remaining_and_remove_todos.dart';
import 'package:flutter_todo_list_v1/widgets/todo_list.dart';
import 'package:provider/provider.dart';

class ToDosPage extends StatefulWidget {
  const ToDosPage({Key? key}) : super(key: key);

  @override
  State<ToDosPage> createState() => _ToDosPageState();
}

class _ToDosPageState extends State<ToDosPage> {
  late final ToDosController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<ToDosController>();
    controller.initToDos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: ValueListenableBuilder<ToDosState>(
            valueListenable: controller.state,
            builder: (context, value, child) {
              switch (value) {
                case ToDosState.loading:
                  return const CircularProgressIndicator();
                default:
                  return Column(
                    children: const [
                      AddToDoWidget(),
                      SizedBox(height: 16.0),
                      ToDoListWidget(),
                      SizedBox(height: 16.0),
                      RemainingAndClearToDosWidget(),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
