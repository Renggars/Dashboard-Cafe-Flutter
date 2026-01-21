// lib/features/pos/data/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cafe/core/data/datasources/auth_local_datasource.dart';
import 'package:cafe/injection.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:4001/v1";
  // Panggil datasource dari GetIt
  final _local = getIt<AuthLocalDatasource>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Ekstraksi data dari JSON
        final data = responseData['data'];
        final String accessToken = data['tokens']['access']['token'];
        final String refreshToken = data['tokens']['refresh']['token'];
        final String username = data['user']['username'];

        // Simpan menggunakan datasource
        await _local.saveAuthData(accessToken, refreshToken, username);

        return {"success": true, "message": "Login success"};
      } else {
        return {
          "success": false,
          "message": responseData['message'] ?? "Login failed"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Koneksi gagal: $e"};
    }
  }
}
