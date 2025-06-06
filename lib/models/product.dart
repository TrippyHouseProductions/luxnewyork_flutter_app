class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final String price;
  final String imagePath;
  final int stock;
  final String sku;

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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toString(),
      imagePath: json['image'],
      category: json['category'] ?? '',
      stock: json['stock'],
      sku: json['sku'] ?? '',
    );
  }

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
