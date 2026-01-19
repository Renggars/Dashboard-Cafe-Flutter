// lib/features/pos/data/models/product.dart

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
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.categoryName,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final categoryData = json['category'] as Map<String, dynamic>?;

    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      imageUrl: json['imageUrl'] != null
          ? 'http://10.0.2.2:4001${json['imageUrl']}'
          : null,
      categoryName: categoryData?['name'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, price, imageUrl, categoryName];

  get category => null;
}
