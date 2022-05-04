import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todo_model.dart';
import 'package:flutter_todo_list_v1/home/todos_database_service.dart';
import 'package:flutter_todo_list_v1/widgets/remove_todo_modal.dart';
import 'package:flutter_todo_list_v1/widgets/update_todo_modal.dart';

import '../widgets/remove_todo_snackbar.dart';

class ToDosController {
  final ToDosDatabaseService _toDosDatabaseService = ToDosDatabaseService();

  final GlobalKey<FormState> addToDosFormKey = GlobalKey<FormState>();
  final TextEditingController addToDosInputController = TextEditingController();
  final FocusNode addToDosInputFocus = FocusNode();
  final TextEditingController updateToDoInputController = TextEditingController();
  final FocusNode updateToDosInputFocusNode = FocusNode();
  late List<ToDo> _toDos;
  final ValueNotifier<bool> todosNotifierFlag = ValueNotifier<bool>(false);

  int? removedToDoIndex;
  ToDo? removedToDo;

  List<ToDo> removedToDoList = [];

  List<ToDo> get toDos => _toDos;

  void notifyToDosNotifierFlagListeners() => todosNotifierFlag.value = !todosNotifierFlag.value;

  Future<void> initToDos() async {
    await _toDosDatabaseService.initDatabase();
    _toDos = await _toDosDatabaseService.readToDos();
  }

  Future<void> reloadToDos() async {
    _toDos = await _toDosDatabaseService.readToDos();
  }

  void validateToDoForm() {
    if (addToDosFormKey.currentState?.validate() ?? false) {
      addToDosFormKey.currentState?.save();
    }
  }

  String? addToDosValidator(String? value) {
    if (value?.isNotEmpty ?? false) {
      return null;
    }

    addToDosInputFocus.requestFocus();
    return 'Type your to-do';
  }

  void addToDo(String? value) async {
    final ToDo newToDo = ToDo(title: value ?? '');
    await _toDosDatabaseService.createToDo(newToDo);
    addToDosInputController.clear();
    await reloadToDos();
    notifyToDosNotifierFlagListeners();
  }

  void showUpdateToDoDialog(BuildContext context, ToDo todo) {
    addToDosInputFocus.unfocus();
    updateToDoInputController.text = todo.title;
    updateToDosInputFocusNode.requestFocus();

    showDialog(
      context: context,
      builder: (context) => UpdateToDoModalWidget(
        context,
        todo: todo,
        controller: updateToDoInputController,
        focusNode: updateToDosInputFocusNode,
        onAccepted: () {
          updateToDo(todo);
          Navigator.of(context).pop();
        },
      ).alertDialog,
      barrierDismissible: false,
    );
  }

  void updateToDo(ToDo todo) async {
    todo.title = updateToDoInputController.text;

    await _toDosDatabaseService.updateToDo(todo);

    notifyToDosNotifierFlagListeners();
  }

  void removeToDo(BuildContext context, {required int index, required ToDo todo}) async {
    removedToDoIndex = index;
    removedToDo = todo;

    toDos.remove(todo);
    await _toDosDatabaseService.deleteToDo(todo);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      RemoveToDoSnackbarWidget(
        context,
        text: 'You have removed ${removedToDo?.title}',
        onPressed: () => undoRemoveToDo(),
      ).snackBar,
    );
    notifyToDosNotifierFlagListeners();
  }

  void undoRemoveToDo() async {
    toDos.insert(removedToDoIndex ?? 0, removedToDo ?? ToDo(title: ''));
    await _toDosDatabaseService.createToDo(removedToDo ?? ToDo(title: ''));
    notifyToDosNotifierFlagListeners();
  }

  void showRemoveAllToDosDialog(BuildContext context) {
    addToDosInputFocus.unfocus();
    showDialog<AlertDialog>(
      context: context,
      builder: (context) => RemoveToDoDialogWidget(
        context,
        title: 'Remove all to-dos?',
        content: 'Are you sure that you want to remove all to-dos?',
        onAccepted: () {
          Navigator.of(context).pop();
          removeAllToDos(context);
        },
      ).alertDialog,
      barrierDismissible: false,
    );
  }

  void removeAllToDos(BuildContext context) async {
    removedToDoList = toDos.toList();

    toDos.clear();
    await _toDosDatabaseService.deleteAllToDos();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      RemoveToDoSnackbarWidget(
        context,
        text: 'You have removed ${removedToDoList.length} To-dos',
        onPressed: () => undoRemoveAllToDos(),
      ).snackBar,
    );
    notifyToDosNotifierFlagListeners();
  }

  void undoRemoveAllToDos() async {
    toDos.addAll(removedToDoList);

    for (var todo in removedToDoList) {
      await _toDosDatabaseService.createToDo(todo);
    }

    notifyToDosNotifierFlagListeners();
  }
}
