import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cafe/core/data/datasources/auth_local_datasource.dart';
import 'package:cafe/injection.dart';
import '../models/setting_model.dart';

class SettingService {
  final String baseUrl = "http://10.0.2.2:4001/v1";

  Future<Map<String, String>> _getHeaders() async {
    final token = await getIt<AuthLocalDatasource>().getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<SettingModel> getGlobalSettings() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/settings'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return SettingModel.fromJson(body);
    } else {
      throw Exception("Gagal mengambil data: ${response.statusCode}");
    }
  }

  Future<void> updateGlobalSettings(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final response = await http.patch(
      Uri.parse('$baseUrl/settings'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      final errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? "Gagal update data");
    }
  }
}
