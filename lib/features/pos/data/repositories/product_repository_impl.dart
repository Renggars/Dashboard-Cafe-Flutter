import 'dart:convert';
import 'package:cafe/features/pos/data/models/product.dart';
import 'package:cafe/features/pos/domain/repositories/product_repository.dart';
import 'package:http/http.dart' as http;

class ProductRepositoryImpl implements ProductRepository {
  // Gunakan alamat IP yang benar untuk emulator atau perangkat fisik
  final String _baseUrl = 'http://10.0.2.2:4001/v1/menu';

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // 1. Decode JSON response body sebagai Map (Objek).
        final Map<String, dynamic> responseData = json.decode(response.body);

        // 2. Akses properti 'data' dari objek tersebut.
        final Map<String, dynamic> dataContainer = responseData['data'];

        // 3. Akses properti 'menus' dari 'data' untuk mendapatkan daftar produk.
        final List<dynamic> productJsonList = dataContainer['menus'];

        // 4. Ubah setiap item di daftar JSON menjadi objek Product.
        return productJsonList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
