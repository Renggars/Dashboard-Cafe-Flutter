import 'package:cafe/features/pos/data/models/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
}
