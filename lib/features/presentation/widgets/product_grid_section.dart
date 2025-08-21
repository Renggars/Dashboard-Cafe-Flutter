import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/data/models/product.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_bloc.dart';

class ProductGridSection extends StatefulWidget {
  const ProductGridSection({super.key});

  @override
  State<ProductGridSection> createState() => _ProductGridSectionState();
}

class _ProductGridSectionState extends State<ProductGridSection> {
  ProductCategory _selectedCategory = ProductCategory.all;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.all(26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildCategoryFilters(),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
          ),
          Expanded(child: _buildProductGrid()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cafe Menu',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Monday, 11 Aug 2025', // Bisa dibuat dinamis dengan package intl
              style: TextStyle(fontSize: 18, color: AppColors.fontGrey),
            ),
          ],
        ),
        const Spacer(),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(
                fontSize: 24,
                color: AppColors.fontGrey,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 30,
                color: AppColors.primary,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildCategoryButton(ProductCategory.all, 'All'),
          _buildCategoryButton(ProductCategory.beverages, 'Beverages'),
          _buildCategoryButton(ProductCategory.snacks, 'Snacks'),
          _buildCategoryButton(ProductCategory.mainCourse, 'Main Course'),
          _buildCategoryButton(ProductCategory.mainCourse, 'Main Course'),
          _buildCategoryButton(ProductCategory.mainCourse, 'Main Course'),
          _buildCategoryButton(ProductCategory.mainCourse, 'Main Course'),
          _buildCategoryButton(ProductCategory.mainCourse, 'Main Course'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(ProductCategory category, String text) {
    final bool isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.white,
          foregroundColor: isSelected ? AppColors.white : AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(150, 80),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // biar sesuai konten
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_pizza_outlined, size: 40),
            const SizedBox(height: 6), // jarak antara icon dan teks
            Text(text, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductLoaded) {
          final filteredProducts = _selectedCategory == ProductCategory.all
              ? state.products
              : state.products
                  .where((p) => p.category == _selectedCategory)
                  .toList();

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8, // rasio lebar : tinggi
              crossAxisSpacing: 16, // jarak antar kolom
              mainAxisSpacing: 16, // jarak antar baris
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(product: filteredProducts[index]);
            },
          );
        }
        if (state is ProductError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Something went wrong!'));
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Image.network(product.imageUrl,
                        fit: BoxFit.contain, height: 80),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.font),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getCategoryName(product.category),
                  style:
                      const TextStyle(fontSize: 16, color: AppColors.fontGrey),
                ),
                const SizedBox(height: 10),
                Text(
                  formatCurrency.format(product.price),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.font,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                context.read<OrderBloc>().add(AddProductToOrder(product));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: AppColors.white, size: 26),
              ),
            ),
          ),
          // Badge untuk item yang sudah diorder
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              final orderItem = state.orderItems
                  .where((item) => item.product.id == product.id)
                  .firstOrNull;
              if (orderItem != null) {
                return Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      orderItem.quantity.toString(),
                      style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  String _getCategoryName(ProductCategory category) {
    switch (category) {
      case ProductCategory.beverages:
        return 'Beverages';
      case ProductCategory.snacks:
        return 'Snacks';
      case ProductCategory.mainCourse:
        return 'Main Course';
      case ProductCategory.desserts:
        return 'Desserts';
      default:
        return '';
    }
  }
}
