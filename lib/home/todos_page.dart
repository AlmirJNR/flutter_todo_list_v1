import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';
import 'package:flutter_todo_list_v1/widgets/add_todo.dart';
import 'package:flutter_todo_list_v1/widgets/remaining_and_remove_todos.dart';
import 'package:flutter_todo_list_v1/widgets/todo_list.dart';

class ToDosPage extends StatelessWidget {
  ToDosPage({Key? key}) : super(key: key);

  final ToDosController controller = ToDosController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do List'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: FutureBuilder(
            future: controller.initToDos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.waiting) {
                return Column(
                  children: [
                    AddToDoWidget(controller: controller),
                    const SizedBox(height: 16.0),
                    ToDoListWidget(controller: controller),
                    const SizedBox(height: 16.0),
                    RemainingAndClearToDosWidget(controller: controller),
                  ],
                );
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
