import 'package:equatable/equatable.dart';

enum ProductCategory { all, beverages, snacks, mainCourse, desserts }

class Product extends Equatable {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final ProductCategory category;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  @override
  List<Object> get props => [id, name, price, imageUrl, category];
}
