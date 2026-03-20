import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

/// Task service using Firestore.
class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'tasks';

  Future<void> addTask(String title) async {
    await _firestore.collection(_collectionName).add({
      'title': title,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Task>> tasksStream() {
    return _firestore
        .collection(_collectionName)
        .orderBy('created_at')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final created = data['created_at'];
        DateTime createdAt;
        if (created == null) {
          createdAt = DateTime.now();
        } else if (created is DateTime) {
          createdAt = created;
        } else {
          createdAt = (created as dynamic).toDate();
        }
        return Task(
          id: doc.id.hashCode.abs(),
          title: data['title'] as String? ?? '',
          createdAt: createdAt,
        );
      }).toList();
    });
  }

  Future<List<Task>> fetchTasks() async {
    final snapshot = await _firestore
        .collection(_collectionName)
        .orderBy('created_at')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final created = data['created_at'];
      DateTime createdAt;
      if (created == null) {
        createdAt = DateTime.now();
      } else if (created is DateTime) {
        createdAt = created;
      } else {
        createdAt = (created as dynamic).toDate();
      }
      return Task(
        id: doc.id.hashCode.abs(),
        title: data['title'] as String? ?? '',
        createdAt: createdAt,
      );
    }).toList();
  }
}
