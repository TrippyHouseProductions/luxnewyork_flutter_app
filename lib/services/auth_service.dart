import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  /// Retrieve the stored authentication token.
  static Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}
