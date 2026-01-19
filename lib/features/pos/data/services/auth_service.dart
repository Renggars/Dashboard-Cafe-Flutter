import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:4001/v1";

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        // Mengikuti struktur JSON: data -> tokens -> access -> token
        final String accessToken =
            responseData['data']['tokens']['access']['token'];
        final String refreshToken =
            responseData['data']['tokens']['refresh']['token'];
        final String username = responseData['data']['user']['username'];

        // Simpan data yang diperlukan ke lokal
        await prefs.setString('token', accessToken);
        await prefs.setString('refresh_token', refreshToken);
        await prefs.setString('username', username);

        return {
          "success": true,
          "message": responseData['message'] ?? "Login success"
        };
      } else {
        // Jika status bukan 200, ambil pesan error dari API jika ada
        return {
          "success": false,
          "message": responseData['message'] ?? "Login failed"
        };
      }
    } catch (e) {
      // Ini akan menangkap error jika parsing JSON gagal atau masalah koneksi
      return {"success": false, "message": "Terjadi kesalahan: $e"};
    }
  }
}
