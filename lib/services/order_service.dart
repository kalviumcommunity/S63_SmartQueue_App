import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/order.dart';
import 'supabase_client.dart';

/// Service layer for order CRUD and real-time sync with Supabase.
/// Uses the `tasks` table (created by supabase/migrations/000_create_tasks_table.sql).
class OrderService {
  final SupabaseClient _client = SupabaseService.client;
  static const String _tableName = 'tasks';

  Future<void> addOrder(String title, {String status = 'Queued'}) async {
    final userId = _client.auth.currentUser?.id;
    await _client.from(_tableName).insert({
      'title': title,
      'status': status,
      ...? (userId != null ? {'user_id': userId} : null),
    });
  }

  Future<void> updateOrder(Order order) async {
    await _client
        .from(_tableName)
        .update(order.toUpdateMap())
        .eq('id', order.id);
  }

  Future<void> deleteOrder(String id) async {
    await _client.from(_tableName).delete().eq('id', id);
  }

  Future<List<Order>> fetchOrders() async {
    final data = await _client
        .from(_tableName)
        .select()
        .order('created_at', ascending: false);

    return (data as List<dynamic>)
        .map((row) => Order.fromMap(row as Map<String, dynamic>))
        .toList();
  }

  Stream<List<Order>> ordersStream() {
    return _client
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((rows) => rows.map((r) => Order.fromMap(r)).toList());
  }
}
