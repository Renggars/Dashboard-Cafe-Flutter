import 'package:cafe/features/pos/data/models/product.dart';

class ProductRepository {
  // Dummy data
  final List<Product> _dummyProducts = [
    const Product(
        id: 1,
        name: 'Coca Cola',
        price: 15000,
        imageUrl:
            'https://cdn-icons-png.flaticon.com/512/1785/1785234.png', // Placeholder URL
        category: ProductCategory.beverages),
    const Product(
        id: 2,
        name: 'Chips',
        price: 4000,
        imageUrl:
            'https://cdn-icons-png.flaticon.com/512/1785/1785233.png', // Placeholder URL
        category: ProductCategory.snacks),
    const Product(
        id: 3,
        name: 'Pizza',
        price: 30000,
        imageUrl:
            'https://cdn-icons-png.flaticon.com/512/3595/3595458.png', // Placeholder URL
        category: ProductCategory.mainCourse),
    const Product(
        id: 4,
        name: 'Chocolate Cake',
        price: 25000,
        imageUrl:
            'https://cdn-icons-png.flaticon.com/512/2674/2674251.png', // Placeholder URL
        category: ProductCategory.desserts),
    const Product(
        id: 5,
        name: 'Ais TEST 100', // Sesuai gambar
        price: 10000,
        imageUrl:
            'https://cdn-icons-png.flaticon.com/512/931/931897.png', // Placeholder URL
        category: ProductCategory.beverages),
    const Product(
        id: 6,
        name: 'Nachos',
        price: 22000,
        imageUrl:
            'https://cdn-icons-png.flaticon.com/512/3480/3480618.png', // Placeholder URL
        category: ProductCategory.snacks),
  ];

  Future<List<Product>> getProducts() async {
    // Simulasi network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _dummyProducts;
  }
}
