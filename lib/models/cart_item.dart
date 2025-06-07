class CartItem {
  final int id;
  final String name;
  final String image;
  final double price;
  int quantity;

  /// NOTE Represents an item in the shopping cart.
  /// NOTE Contains fields for id, name, image URL, price, and quantity.
  CartItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}
