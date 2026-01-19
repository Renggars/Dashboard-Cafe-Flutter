import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cafe/features/pos/data/models/product.dart';
import 'package:cafe/features/pos/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final String baseUrl = "http://10.0.2.2:4001/v1/menu";

  @override
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      // Response backend: { "data": { "menus": [...] } }
      final List listMenus = data['data']['menus'];
      return listMenus.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
