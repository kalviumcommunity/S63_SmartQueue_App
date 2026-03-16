/// Order model for vendor queue items stored in Supabase.
class Order {
  final String id;
  final String title;
  final String status;
  final DateTime createdAt;
  final String? userId;

  Order({
    required this.id,
    required this.title,
    required this.status,
    required this.createdAt,
    this.userId,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: (map['id'] ?? '').toString(),
      title: map['title'] as String,
      status: map['status'] as String? ?? 'Queued',
      createdAt: DateTime.parse(map['created_at'] as String),
      userId: map['user_id'] as String?,
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'title': title,
      'status': status,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'title': title,
      'status': status,
    };
  }

  Order copyWith({
    String? id,
    String? title,
    String? status,
    DateTime? createdAt,
    String? userId,
  }) {
    return Order(
      id: id ?? this.id,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
