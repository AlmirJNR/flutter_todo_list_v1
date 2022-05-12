import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todo_model.dart';
import 'package:flutter_todo_list_v1/home/todos_database_service.dart';

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
  ToDo? get removedToDo => _removedToDo;
  List<ToDo> get removedToDoList => _removedToDoList;

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

  void showUpdateToDoDialog({required ToDo todo, required void Function() showDialog}) {
    addToDosInputFocus.unfocus();
    updateToDoInputController.text = todo.title;
    updateToDosInputFocusNode.requestFocus();

    showDialog();
  }

  void updateToDo(ToDo todo) async {
    todo.title = updateToDoInputController.text;

    await _toDosDatabaseService.updateToDo(todo);

    notifyListeners();
  }

  void removeToDo({required int index, required ToDo todo, required void Function() showSnackbar}) async {
    _removedToDoIndex = index;
    _removedToDo = todo;

    toDos.remove(todo);
    await _toDosDatabaseService.deleteToDo(todo);
    showSnackbar();
    notifyListeners();
  }

  void undoRemoveToDo() async {
    toDos.insert(_removedToDoIndex ?? 0, _removedToDo ?? ToDo(title: ''));
    await _toDosDatabaseService.createToDo(_removedToDo ?? ToDo(title: ''));
    notifyListeners();
  }

  void showRemoveAllToDosDialog(void Function() showDialog) {
    addToDosInputFocus.unfocus();
    showDialog();
  }

  void removeAllToDos(void Function() showSnackbar) async {
    _removedToDoList = toDos.toList();

    toDos.clear();
    await _toDosDatabaseService.deleteAllToDos();
    showSnackbar();
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
