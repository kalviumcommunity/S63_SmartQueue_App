import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/task.dart';
import 'supabase_client.dart';

class TaskService {
  final SupabaseClient _client = SupabaseService.client;

  static const String tableName = 'tasks';

  Future<void> addTask(String title) async {
    await _client.from(tableName).insert(
      Task(
        id: 0,
        title: title,
        createdAt: DateTime.now(),
      ).toInsertMap(),
    );
  }

  Stream<List<Task>> tasksStream() {
    return _client
        .from(tableName)
        .stream(primaryKey: ['id'])
        .order('created_at')
        .map(
          (rows) => rows.map((row) => Task.fromMap(row)).toList(),
        );
  }

  Future<List<Task>> fetchTasks() async {
    final response = await _client.from(tableName).select().order(
          'created_at',
        );

    final data = response as List<dynamic>;
    return data.map((row) => Task.fromMap(row as Map<String, dynamic>)).toList();
  }
}

