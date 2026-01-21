import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  static const String _tokenKey = 'token';
  static const String _refreshKey = 'refresh_token';
  static const String _userKey = 'username';

  Future<void> saveAuthData(
      String token, String refresh, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_refreshKey, refresh);
    await prefs.setString(_userKey, username);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
