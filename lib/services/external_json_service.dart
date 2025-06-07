import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import '../models/about_item.dart';

class ExternalJsonService {
  static const String _remoteUrl =
      'https://raw.githubusercontent.com/TrippyHouseProductions/JSON-data/refs/heads/main/about-items.json';

  static Future<List<AboutItem>> fetchAboutItems() async {
    try {
      final response = await http.get(Uri.parse(_remoteUrl));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList =
            jsonDecode(response.body) as List<dynamic>;
        return jsonList
            .map((item) => AboutItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      // ignore and fall back to asset
    }

    final data = await rootBundle.loadString('assets/data/about_items.json');
    final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
    return jsonList
        .map((item) => AboutItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
