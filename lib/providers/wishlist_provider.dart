// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:luxnewyork_flutter_app/models/product.dart';

// class WishlistProvider extends ChangeNotifier {
//   final List<Product> _wishlist = [];

//   List<Product> get wishlist => _wishlist;

//   WishlistProvider() {
//     _loadWishlist(); // Load wishlist from local storage on initialization
//   }

//   void toggleWishlist(Product product) {
//     final index = _wishlist.indexWhere((item) => item.id == product.id);
//     if (index >= 0) {
//       _wishlist.removeAt(index);
//     } else {
//       _wishlist.add(product);
//     }
//     _saveWishlist();
//     notifyListeners();
//   }

//   bool isInWishlist(int productId) {
//     return _wishlist.any((product) => product.id == productId);
//   }

//   void clearWishlist() {
//     _wishlist.clear();
//     _saveWishlist();
//     notifyListeners();
//   }

//   // NOTE Save wishlist to local storage
//   Future<void> _saveWishlist() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> wishlistJson =
//         _wishlist.map((product) => jsonEncode(_productToMap(product))).toList();
//     await prefs.setStringList('wishlist', wishlistJson);
//   }

//   // NOTE Load wishlist from local storage
//   Future<void> _loadWishlist() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String>? wishlistJson = prefs.getStringList('wishlist');

//     if (wishlistJson != null) {
//       _wishlist.clear();
//       for (String jsonStr in wishlistJson) {
//         final Map<String, dynamic> productMap = jsonDecode(jsonStr);
//         _wishlist.add(_productFromMap(productMap));
//       }
//       notifyListeners();
//     }
//   }

//   // NOTE Convert Product to Map
//   Map<String, dynamic> _productToMap(Product product) => {
//         'id': product.id,
//         'name': product.name,
//         'description': product.description,
//         'category': product.category,
//         'price': product.price,
//         'imagePath': product.imagePath,
//         'stock': product.stock,
//       };

//   // NOTE Convert Map to Product
//   Product _productFromMap(Map<String, dynamic> map) => Product(
//         id: map['id'],
//         name: map['name'],
//         description: map['description'],
//         category: map['category'],
//         price: map['price'],
//         imagePath: map['imagePath'],
//         stock: map['stock'],
//       );
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:luxnewyork_flutter_app/models/product.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class WishlistProvider extends ChangeNotifier {
//   List<Product> _wishlist = [];

//   List<Product> get wishlist => _wishlist;

//   Future<void> loadWishlist() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token') ?? '';

//     try {
//       final response = await http.get(
//         Uri.parse('http://10.0.2.2:8000/api/wishlist'),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         final items = responseData['data']['items'] as List;

//         _wishlist =
//             items.map((item) => Product.fromJson(item['product'])).toList();

//         notifyListeners();
//       } else {
//         print('Response: ${response.body}');
//         throw Exception('Failed to load wishlist: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('ERROR loading wishlist: $e');
//       throw Exception('Failed to load wishlist');
//     }
//   }

//   void toggleWishlist(Product product) {
//     final index = _wishlist.indexWhere((item) => item.id == product.id);
//     if (index >= 0) {
//       _wishlist.removeAt(index);
//     } else {
//       _wishlist.add(product);
//     }
//     notifyListeners();
//   }

//   bool isInWishlist(int productId) {
//     return _wishlist.any((product) => product.id == productId);
//   }

//   void clearWishlist() {
//     _wishlist.clear();
//     notifyListeners();
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:luxnewyork_flutter_app/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  List<Product> _wishlist = [];

  List<Product> get wishlist => _wishlist;

  // Fetch wishlist from API based on logged-in user
  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/wishlist'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['data']['items'];

        _wishlist =
            items.map((item) => Product.fromJson(item['product'])).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Wishlist load error: $e');
      throw Exception('Failed to load wishlist');
    }
  }

  void toggleWishlist(Product product) {
    final index = _wishlist.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();

    // NOTE: optionally you can send the add/remove to the API here
  }

  bool isInWishlist(int productId) {
    return _wishlist.any((product) => product.id == productId);
  }

  void clearWishlist() {
    _wishlist.clear();
    notifyListeners();
  }
}
