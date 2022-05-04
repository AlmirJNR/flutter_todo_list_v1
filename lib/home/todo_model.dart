class ToDo {
  ToDo({this.id, required this.title, this.date}) {
    date ??= DateTime.now();
  }

  int? id;
  String title;
  DateTime? date;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date?.toIso8601String(),
    };
  }

  @override
  String toString() =>
'''
ToDo {
  id: $id,
  title: $title,
  date: $date,
}''';
}
