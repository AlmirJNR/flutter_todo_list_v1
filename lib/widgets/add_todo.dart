import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todos_controller.dart';

class AddToDoWidget extends StatelessWidget {
  const AddToDoWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ToDosController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Form(
            key: controller.addToDosFormKey,
            child: TextFormField(
              controller: controller.addToDosInputController,
              focusNode: controller.addToDosInputFocus,
              keyboardType: TextInputType.text,
              maxLength: 50,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'To-do description',
              ),
              onEditingComplete: controller.validateToDoForm,
              validator: controller.addToDosValidator,
              onSaved: controller.addToDo,
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: controller.validateToDoForm,
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.symmetric(vertical: 18.0)),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
