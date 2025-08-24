import 'package:cafe/features/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_bloc.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_event.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_state.dart';
import 'package:cafe/features/pos/data/repositories/category_repository_impl.dart';
import 'package:cafe/features/pos/data/models/category.dart';

class ProductGridSection extends StatefulWidget {
  const ProductGridSection({super.key});

  @override
  State<ProductGridSection> createState() => _ProductGridSectionState();
}

class _ProductGridSectionState extends State<ProductGridSection> {
  String _selectedCategory = 'all';
  final _searchController = TextEditingController();
  final _categoryRepository = CategoryRepositoryImpl();
  late Future<List<Category>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    // Inisialisasi future untuk mengambil kategori di initState
    _categoriesFuture = _categoryRepository.getCategories();
    context.read<ProductBloc>().add(FetchProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
          const Divider(height: 1),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cafe Menu',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              DateFormat('EEEE, d MMM yyyy').format(DateTime.now()),
              style: const TextStyle(fontSize: 18, color: AppColors.fontGrey),
            ),
          ],
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(
                fontSize: 20,
                color: AppColors.fontGrey,
              ),
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
                color: AppColors.primary,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            ),
            onChanged: (query) {
              // TODO: Implementasi logika pencarian produk
              print("Pencarian produk logic");
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilters() {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan loading saat data kategori sedang diambil
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Tampilkan pesan error jika pengambilan data gagal
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Jika data berhasil diambil
          final categories = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final bool isSelected =
                    _selectedCategory == category.name.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategory = category.name.toLowerCase();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSelected ? AppColors.primary : AppColors.white,
                      foregroundColor:
                          isSelected ? AppColors.white : AppColors.primary,
                      elevation: isSelected ? 4 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: isSelected
                            ? BorderSide.none
                            : const BorderSide(
                                color: AppColors.fontGrey, width: 1),
                      ),
                      minimumSize: const Size(120, 80),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Menggunakan Icon yang sesuai atau hanya Teks
                        const Icon(Icons.category,
                            size: 30), // Ganti dengan ikon yang relevan
                        const SizedBox(height: 6),
                        Text(category.name,
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductLoaded) {
          final filteredProducts = _selectedCategory == 'all'
              ? state.products
              : state.products
                  .where(
                      (p) => p.categoryName?.toLowerCase() == _selectedCategory)
                  .toList();

          if (filteredProducts.isEmpty) {
            return const Center(
                child: Text('No products found in this category.'));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return ProductCard(product: product);
            },
          );
        }
        if (state is ProductError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(
            child: Text('Please select a category or search for a product.'));
      },
    );
  }
}
