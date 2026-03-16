import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../widgets/task_input.dart';
import '../widgets/task_list.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key});

  final TaskService _taskService = TaskService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: Padding
(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TaskInput(
              onSubmit: (title) => _taskService.addTask(title),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _taskService.tasksStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading tasks: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final tasks = snapshot.data ?? [];
                  return TaskList(tasks: tasks);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

