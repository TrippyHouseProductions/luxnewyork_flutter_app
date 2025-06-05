class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final String price;
  final String imagePath;
  final int stock; // ✅ New field

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imagePath,
    required this.stock,
    required sku, // ✅ Include in constructor
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toString(), // or convert if needed
      imagePath: json['image'],
      category: '', // if needed, you can add a separate API call for category
      stock: json['stock'],
      sku: json['sku'],
    );
  }

  toJson() {}
}
