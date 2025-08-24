import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cafe/features/pos/data/models/category.dart';
import 'package:cafe/features/pos/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  // Gunakan alamat IP yang benar untuk emulator atau perangkat fisik
  final String _baseUrl = 'http://10.0.2.2:4001/v1/category';

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> categoryJsonList =
            responseData['data']['categories'];

        // Tambahkan kategori "all" secara manual di awal daftar
        final List<Category> categories = [Category(id: 0, name: 'all')];

        categories.addAll(
            categoryJsonList.map((json) => Category.fromJson(json)).toList());

        return categories;
      } else {
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the API: $e');
    }
  }
}
