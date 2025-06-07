class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final String price;
  final String imagePath;
  final int stock;
  final String sku;

  /// NOTE Represents a product in the e-commerce application.
  /// NOTE Contains fields for id, name, description, category, price, image path, stock quantity, and SKU.
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imagePath,
    required this.stock,
    required this.sku,
  });

  /// NOTE Factory constructor to create a Product instance from a JSON map.
  /// NOTE Handles both string and Map types for name, description, image, and category.
  factory Product.fromJson(Map<String, dynamic> json) {
    String extractString(dynamic value) {
      if (value is String) return value;
      if (value is Map && value.containsKey('en')) {
        return value['en'].toString();
      }
      return value.toString();
    }

    return Product(
      id: json['id'],
      name: extractString(json['name']),
      description: extractString(json['description']),
      price: json['price'].toString(),
      imagePath: extractString(json['image']),
      category: json['category'] is Map
          ? extractString(json['category']['name'])
          : extractString(json['category']),
      stock: json['stock'],
      sku: extractString(json['sku']),
    );
  }

  /// NOTE Converts the Product instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image': imagePath,
      'stock': stock,
      'sku': sku,
    };
  }
}
