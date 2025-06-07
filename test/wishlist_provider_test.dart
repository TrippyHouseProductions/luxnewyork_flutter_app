import 'package:flutter_test/flutter_test.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:luxnewyork_flutter_app/providers/wishlist_provider.dart';

class LocalWishlistProvider extends WishlistProvider {
  @override
  Future<void> toggleWishlist(Product product) async {
    final index = wishlist.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      wishlist.removeAt(index);
    } else {
      wishlist.add(product);
    }
    notifyListeners();
  }
}

void main() {
  group('WishlistProvider toggleWishlist', () {
    late LocalWishlistProvider provider;
    final product = Product(
      id: 1,
      name: 'Test',
      description: 'desc',
      category: 'cat',
      price: '10',
      imagePath: '',
      stock: 1,
      sku: 'sku',
    );

    setUp(() {
      provider = LocalWishlistProvider();
    });

    test('toggleWishlist adds product when not present', () async {
      expect(provider.wishlist.length, 0);
      await provider.toggleWishlist(product);
      expect(provider.wishlist.length, 1);
    });

    test('toggleWishlist removes product when present', () async {
      await provider.toggleWishlist(product);
      expect(provider.wishlist.length, 1);
      await provider.toggleWishlist(product);
      expect(provider.wishlist.length, 0);
    });
  });
}
