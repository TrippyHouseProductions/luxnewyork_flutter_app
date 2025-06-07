import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:shared_preferences/shared_preferences.dart';

/// Provider that detects the user's country using the device location and
/// exposes the currency code based on that country.
class LocationProvider extends ChangeNotifier {
  String _currency = 'LKR';
  final double _aedToLkr = 81.45; // basic static exchange rate

  String get currency => _currency;

  double convertPrice(double priceInAed) {
    if (_currency == 'LKR') {
      return priceInAed * _aedToLkr;
    }
    return priceInAed;
  }

  /// Load any previously saved currency and attempt to detect the location
  /// in the background.
  Future<void> init() async {
    await _loadCurrency();
    _detectLocation();
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString('currency') ?? 'LKR';
    notifyListeners();
  }

  Future<void> _detectLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      final placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final country = placemarks.first.country?.toLowerCase() ?? '';
        if (country.contains('sri lanka')) {
          _currency = 'LKR';
        } else if (country.contains('united arab emirates') ||
            country.contains('dubai')) {
          _currency = 'AED';
        }
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('currency', _currency);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Location detection error: $e');
    }
  }
}
