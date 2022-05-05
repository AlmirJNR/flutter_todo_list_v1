import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todo_model.dart';
import 'package:flutter_todo_list_v1/home/todos_database_service.dart';
import 'package:flutter_todo_list_v1/widgets/remove_todo_modal.dart';
import 'package:flutter_todo_list_v1/widgets/update_todo_modal.dart';

import '../widgets/remove_todo_snackbar.dart';

enum ToDosState { loading, initialized }

class ToDosController extends ChangeNotifier {
  final ToDosDatabaseService _toDosDatabaseService;

  final GlobalKey<FormState> addToDosFormKey = GlobalKey<FormState>();

  final TextEditingController addToDosInputController = TextEditingController();
  final TextEditingController updateToDoInputController = TextEditingController();
  final FocusNode addToDosInputFocus = FocusNode();
  final FocusNode updateToDosInputFocusNode = FocusNode();

  ValueNotifier<ToDosState> state = ValueNotifier(ToDosState.loading);

  late List<ToDo> _toDos;

  int? _removedToDoIndex;
  ToDo? _removedToDo;

  List<ToDo> _removedToDoList = [];

  ToDosController(this._toDosDatabaseService);

  List<ToDo> get toDos => _toDos;

  Future<void> initToDos() async {
    await _toDosDatabaseService.initDatabase();
    _toDos = await _toDosDatabaseService.readToDos();

    state.value = ToDosState.initialized;
  }

  Future<void> reloadToDos() async {
    _toDos = await _toDosDatabaseService.readToDos();
    notifyListeners();
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

    notifyListeners();
  }

  void removeToDo(BuildContext context, {required int index, required ToDo todo}) async {
    _removedToDoIndex = index;
    _removedToDo = todo;

    toDos.remove(todo);
    await _toDosDatabaseService.deleteToDo(todo);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      RemoveToDoSnackbarWidget(
        context,
        text: 'You have removed ${_removedToDo?.title}',
        onPressed: () => undoRemoveToDo(),
      ).snackBar,
    );
    notifyListeners();
  }

  void undoRemoveToDo() async {
    toDos.insert(_removedToDoIndex ?? 0, _removedToDo ?? ToDo(title: ''));
    await _toDosDatabaseService.createToDo(_removedToDo ?? ToDo(title: ''));
    notifyListeners();
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
    _removedToDoList = toDos.toList();

    toDos.clear();
    await _toDosDatabaseService.deleteAllToDos();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      RemoveToDoSnackbarWidget(
        context,
        text: 'You have removed ${_removedToDoList.length} To-dos',
        onPressed: () => undoRemoveAllToDos(),
      ).snackBar,
    );
    notifyListeners();
  }

  void undoRemoveAllToDos() async {
    toDos.addAll(_removedToDoList);

    for (var todo in _removedToDoList) {
      await _toDosDatabaseService.createToDo(todo);
    }

    notifyListeners();
  }
}
