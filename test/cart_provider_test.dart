import 'package:flutter_test/flutter_test.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:luxnewyork_flutter_app/providers/cart_provider.dart';

class LocalCartProvider extends CartProvider {
  @override
  Future<void> addItem(Product product) async {
    items.add(product);
    notifyListeners();
  }

  @override
  Future<void> removeItem(int productId) async {
    items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}

void main() {
  group('CartProvider itemCount', () {
    late LocalCartProvider provider;
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
      provider = LocalCartProvider();
    });

    test('adding item increases itemCount', () async {
      expect(provider.itemCount, 0);
      await provider.addItem(product);
      expect(provider.itemCount, 1);
    });

    test('removing item decreases itemCount', () async {
      await provider.addItem(product);
      expect(provider.itemCount, 1);
      await provider.removeItem(product.id);
      expect(provider.itemCount, 0);
    });
  });
}
