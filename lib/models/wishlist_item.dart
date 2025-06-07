class WishlistItem {
  final int id;
  final String name;
  final String image;
  final double price;

  /// NOTE Represents an item in the wishlist.
  /// NOTE Contains fields for id, name, image URL, and price.
  WishlistItem({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });
}
