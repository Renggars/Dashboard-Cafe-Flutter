import 'package:cafe/features/presentation/widgets/manageProductWidgets/category_create_form.dart';
import 'package:cafe/features/presentation/widgets/manageProductWidgets/category_list_module.dart';
import 'package:cafe/features/presentation/widgets/manageProductWidgets/create_product_form.dart';
import 'package:cafe/features/presentation/widgets/manageProductWidgets/product_list_module.dart';
import 'package:flutter/material.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  String selectedMenu = "product_create";

  // Palette warna biru modern
  final Color primaryBlue = const Color(0xFF0061FF);
  final Color lightBlueBg = const Color(0xFFF0F5FF);
  final Color sidebarText = const Color(0xFF4B5563);

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    switch (selectedMenu) {
      case "product_create":
        return const CreateProductForm(key: ValueKey("pc"));
      case "product_list":
        return const ProductListModule(key: ValueKey("pl"));
      case "category_create":
        return const CategoryCreateForm(key: ValueKey("cc"));
      case "category_list":
        return const CategoryListModule(key: ValueKey("cl"));
      default:
        return const CreateProductForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background Utama Putih
      body: Row(
        children: [
          _buildSidebar(),
          // Vertical Divider halus antara sidebar dan konten
          Container(width: 1, color: Colors.grey.shade100),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    String title = "";
    if (selectedMenu.contains("product")) title = "Manajemen Produk";
    if (selectedMenu.contains("category")) title = "Manajemen Kategori";

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937)),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text("Administrator",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w500)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 300,
      color: Colors.white, // Sidebar Putih
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 60, 24, 40),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.storefront,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CAFE POS",
                        style: TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
          _sectionTitle("PRODUK"),
          _sidebarItem(
              "Tambah Produk", Icons.add_box_rounded, "product_create"),
          _sidebarItem(
              "Daftar Produk", Icons.inventory_2_rounded, "product_list"),
          const SizedBox(height: 24),
          _sectionTitle("KATEGORI"),
          _sidebarItem("Tambah Kategori", Icons.create_new_folder_rounded,
              "category_create"),
          _sidebarItem(
              "Daftar Kategori", Icons.category_rounded, "category_list"),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Text(
        title,
        style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5),
      ),
    );
  }

  Widget _sidebarItem(String title, IconData icon, String value) {
    bool isSelected = selectedMenu == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => setState(() => selectedMenu = value),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            // Warna Biru saat aktif, transparan saat tidak
            color: isSelected ? lightBlueBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? primaryBlue : sidebarText,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? primaryBlue : sidebarText,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (isSelected) const Spacer(),
              if (isSelected)
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    shape: BoxShape.circle,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
