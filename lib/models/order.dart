class OrderItem {
  final int id;
  final String name;
  final int quantity;
  final String price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['product']?['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price']?.toString() ?? '',
    );
  }
}

class Order {
  final int id;
  final String status;
  final String total;
  final String date;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.status,
    required this.total,
    required this.date,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List?) ?? [];
    return Order(
      id: json['id'],
      status: json['status']?.toString() ?? '',
      total: json['total']?.toString() ?? '',
      date: json['date']?.toString() ?? json['created_at']?.toString() ?? '',
      items: itemsJson.map((e) => OrderItem.fromJson(e)).toList(),
    );
  }
}
