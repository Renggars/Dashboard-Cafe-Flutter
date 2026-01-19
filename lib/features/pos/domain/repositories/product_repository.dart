// lib/features/pos/data/repositories/product_repository.dart

import 'package:cafe/features/pos/data/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
