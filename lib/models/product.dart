class Product {
  final int id;
  final String name;
  final String description;
  final String category;
  final String price;
  final String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.imagePath,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category']['name'], // Nested inside category
      price: json['price'].toString(),
      imagePath: json['image'],
    );
  }
}
