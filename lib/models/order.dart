/// Order model for vendor queue items stored in Firestore.
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

  /// Parse from Firestore document.
  factory Order.fromFirestore(String id, Map<String, dynamic> data) {
    final created = data['created_at'];
    DateTime createdAt;
    if (created == null) {
      createdAt = DateTime.now();
    } else if (created is DateTime) {
      createdAt = created;
    } else {
      createdAt = (created as dynamic).toDate();
    }
    return Order(
      id: id,
      title: data['title'] as String? ?? '',
      status: data['status'] as String? ?? 'Queued',
      createdAt: createdAt,
      userId: data['user_id'] as String?,
    );
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
