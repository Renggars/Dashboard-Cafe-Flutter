import 'package:equatable/equatable.dart';

enum ProductCategory {
  all,
  beverages,
  snacks,
  mainCourse,
  desserts;

  toLowerCase() {}
}

class Product extends Equatable {
  final int id;
  final String name;
  final int price;
  final String? categoryName;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final categoryData = json['category'] as Map<String, dynamic>?;
    final categoryName = categoryData?['name'] as String?;

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      categoryName: categoryName,
    );
  }

  @override
  List<Object?> get props => [id, name, price, categoryName];
}
