import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order.dart' as order_model;

/// Service layer for order CRUD and real-time sync with Firestore.
class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'orders';

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(_collectionName);

  Future<void> addOrder(String title, {String status = 'Queued'}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await _collection.add({
      'title': title,
      'status': status,
      'created_at': FieldValue.serverTimestamp(),
      ...? (userId != null ? {'user_id': userId} : null),
    });
  }

  Future<void> updateOrder(order_model.Order order) async {
    await _collection.doc(order.id).update(order.toUpdateMap());
  }

  Future<void> deleteOrder(String id) async {
    await _collection.doc(id).delete();
  }

  Future<List<order_model.Order>> fetchOrders() async {
    final snapshot = await _collection
        .orderBy('created_at', descending: true)
        .get();
    return snapshot.docs
        .map((d) => order_model.Order.fromFirestore(d.id, d.data()))
        .toList();
  }

  Stream<List<order_model.Order>> ordersStream() {
    return _collection
        .orderBy('created_at', descending: true)
        .snapshots()
        .map<List<order_model.Order>>((snapshot) => snapshot.docs
            .map((d) => order_model.Order.fromFirestore(d.id, d.data()))
            .toList());
  }
}
