class Category {
  final int id;
  final String name;

  /// NOTE Represents a category in the e-commerce application.
  /// NOTE Contains fields for id and name.
  Category({required this.id, required this.name});

  /// NOTE Factory constructor to create a Category instance from a JSON map.
  /// NOTE Handles both string and Map types for name.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
