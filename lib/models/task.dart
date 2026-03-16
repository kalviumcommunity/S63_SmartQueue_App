class Task {
  final int id;
  final String title;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'title': title,
    };
  }
}

