import 'package:flutter/material.dart';
import 'package:cafe/features/pos/data/services/product_service.dart';
import 'package:cafe/features/pos/data/services/category_service.dart';
import 'dart:developer' as dev;

class ProductListModule extends StatefulWidget {
  const ProductListModule({super.key});

  @override
  State<ProductListModule> createState() => _ProductListModuleState();
}

class _ProductListModuleState extends State<ProductListModule> {
  final _productService = ProductService();
  final _categoryService = CategoryService();

  // Konfigurasi Server
  final String baseUrl = "http://10.0.2.2:4001";

  List<dynamic> _allProducts = [];
  List<dynamic> _filteredProducts = [];
  List<dynamic> _categories = [];

  bool _isLoading = true;
  String _searchQuery = "";
  String _selectedCategory = "All";

  final Color primaryBlue = const Color(0xFF0061FF);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productService.getMenus();
      final categories = await _categoryService.getCategories();

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      dev.log("Error loading data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _applyFilter() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final name = (product['name'] ?? "").toString().toLowerCase();
        final matchesSearch = name.contains(_searchQuery.toLowerCase());

        final categoryName =
            product['category'] != null ? product['category']['name'] : "";
        final matchesCategory =
            _selectedCategory == "All" || categoryName == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildFilterAndSearchSection(),
            const SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryBlue))
                  : _buildModernProductTable(constraints.maxWidth),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Daftar Produk",
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937))),
            Text("Total ${_allProducts.length} menu tersedia",
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _loadData,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text("Refresh Data"),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue.withOpacity(0.1),
            foregroundColor: primaryBlue,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        )
      ],
    );
  }

  Widget _buildFilterAndSearchSection() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
              ],
            ),
            child: TextField(
              onChanged: (val) {
                _searchQuery = val;
                _applyFilter();
              },
              decoration: InputDecoration(
                hintText: "Cari nama produk...",
                prefixIcon: Icon(Icons.search_rounded, color: primaryBlue),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("All"),
                ..._categories.map((cat) => _buildFilterChip(cat['name'])),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = label;
          _applyFilter();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected ? primaryBlue : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildModernProductTable(double maxWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: maxWidth - 64),
              child: DataTable(
                headingRowColor:
                    MaterialStateProperty.all(const Color(0xFFF9FAFB)),
                dataRowMaxHeight: 110,
                headingRowHeight: 70,
                horizontalMargin: 24,
                columnSpacing: 20,
                columns: const [
                  DataColumn(
                      label: Text('GAMBAR',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('NAMA PRODUK',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('KATEGORI',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('HARGA',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('AKSI',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _filteredProducts.map((product) {
                  // Penanganan URL Gambar
                  final String? rawPath = product['imageUrl'];
                  String fullImageUrl = "";
                  if (rawPath != null && rawPath.isNotEmpty) {
                    fullImageUrl = rawPath.startsWith('http')
                        ? rawPath
                        : "$baseUrl$rawPath";
                  }

                  return DataRow(cells: [
                    DataCell(_buildImageWidget(fullImageUrl)),
                    DataCell(
                      SizedBox(
                        width: maxWidth * 0.25, // Agar kolom nama lebar
                        child: Text(product['name'] ?? "-",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                    ),
                    DataCell(_buildCategoryBadge(
                        product['category']?['name'] ?? "-")),
                    DataCell(Text("Rp ${product['price']}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600))),
                    DataCell(_buildActionButtons()),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String url) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade100,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: url.isEmpty
            ? _buildPlaceholder()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  dev.log("Gagal load gambar: $url");
                  return _buildPlaceholder();
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2));
                },
              ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey.shade100,
      child: Icon(Icons.broken_image_outlined,
          color: Colors.grey.shade400, size: 30),
    );
  }

  Widget _buildCategoryBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
            color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSmallActionBtn(Icons.edit_rounded, Colors.orange, () {}),
        const SizedBox(width: 12),
        _buildSmallActionBtn(Icons.delete_rounded, Colors.red, () {}),
      ],
    );
  }

  Widget _buildSmallActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return IconButton.filledTonal(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
