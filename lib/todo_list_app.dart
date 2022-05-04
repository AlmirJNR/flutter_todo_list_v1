import 'package:flutter/material.dart';
import 'package:flutter_todo_list_v1/home/todos_page.dart';

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-do List',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch:Colors.blue,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.blue,
          actionTextColor: Colors.white,
        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blueGrey,
        ),
        scaffoldBackgroundColor: Colors.black,
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.blueGrey,
          actionTextColor: Colors.white,
        ),
      ),
      home: ToDosPage(),
    );
  }
}
