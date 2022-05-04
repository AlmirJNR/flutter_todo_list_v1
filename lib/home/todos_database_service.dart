import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_todo_list_v1/home/todo_model.dart';

class ToDosDatabaseService {
  late final Database _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), 'todos_database.db'),
        onCreate: (db, version) {
          return db.execute('CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, date TEXT)');
        },
        version: 1,
      );
  }

  Future<void> createToDo(ToDo todo) async {
    _database.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ToDo>> readToDos() async {
    final List<Map<String, dynamic>> response = await _database.query('todos', groupBy: 'date');

    return List.generate(
      response.length,
      (index) => ToDo(
        id: response[index]['id'],
        title: response[index]['title'],
        date: DateTime.tryParse(response[index]['date']),
      ),
    );
  }

  Future<void> updateToDo(ToDo todo) async {
    _database.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteToDo(ToDo todo) async {
    _database.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteAllToDos() async {
    _database.rawQuery('DELETE FROM todos');
  }
}
