import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cafe/core/data/datasources/auth_local_datasource.dart';
import 'package:cafe/features/pos/data/models/order_request.dart';
import 'package:cafe/injection.dart';

/// Abstract class sebagai interface repository
abstract class OrderRepository {
  Future<Map<String, dynamic>> createOrder(OrderRequest request);

  Future<Map<String, dynamic>> getOrders({
    required String status,
    String search = '',
    int page = 1,
    int limit = 25,
  });
}

/// Implementasi repository untuk koneksi ke API backend
class OrderRepositoryImpl implements OrderRepository {
  final String baseUrl = "http://10.0.2.2:4001/v1";

  @override
  Future<Map<String, dynamic>> getOrders({
    required String status,
    String search = '',
    int page = 1,
    int limit = 25,
  }) async {
    final token = await getIt<AuthLocalDatasource>().getToken();

    // 1. Prisma Enum Case-Sensitivity fix:
    // Mengubah status (pending -> PENDING) agar sesuai dengan skema Prisma
    final String formattedStatus = status.toUpperCase();

    // 2. Menyusun Query Parameters secara dinamis
    final Map<String, String> queryParams = {
      'status': formattedStatus,
      'page': page.toString(),
      'limit': limit.toString(),
    };

    // Hanya masukkan parameter search jika ada isinya agar tidak error 400
    if (search.trim().isNotEmpty) {
      queryParams['search'] = search;
    }

    // Membangun URI lengkap dengan query parameters
    final uri =
        Uri.parse('$baseUrl/order').replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return body['data'];
      } else {
        // Mencetak error ke console untuk mempermudah debug
        throw body['message'] ?? "Gagal mengambil data pesanan";
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder(OrderRequest request) async {
    final token = await getIt<AuthLocalDatasource>().getToken();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/order'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return body['data'] ?? body;
      } else {
        throw body['message'] ?? "Gagal memproses pesanan";
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
