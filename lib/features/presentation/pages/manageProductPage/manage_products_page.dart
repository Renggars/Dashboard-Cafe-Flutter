// lib/features/presentation/pages/manageProductPage/manage_products_page.dart

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
  // Default menu yang terbuka pertama kali
  String selectedMenu = "product_create";

  Widget _buildContent() {
    switch (selectedMenu) {
      case "product_create":
        return const CreateProductForm();
      case "product_list":
        return const ProductListModule();
      case "category_create":
        return const CategoryCreateForm(); // File Baru
      case "category_list":
        return const CategoryListModule(); // File Baru
      default:
        return const CreateProductForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          const DrawerHeader(
              child: Center(
                  child: Text("Admin Panel",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)))),

          // SECTION PRODUCT
          _sectionTitle("PRODUCT"),
          _sidebarItem(
              "Create Product", Icons.add_box_outlined, "product_create"),
          _sidebarItem(
              "List Product", Icons.inventory_2_outlined, "product_list"),

          const SizedBox(height: 20),

          // SECTION CATEGORY
          _sectionTitle("CATEGORY"),
          _sidebarItem("Create Category", Icons.create_new_folder_outlined,
              "category_create"),
          _sidebarItem(
              "List Category", Icons.category_outlined, "category_list"),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 10, bottom: 5),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold))),
    );
  }

  Widget _sidebarItem(String title, IconData icon, String value) {
    bool isSelected = selectedMenu == value;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.deepPurple : Colors.grey),
      title: Text(title,
          style: TextStyle(
              color: isSelected ? Colors.deepPurple : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onTap: () => setState(() => selectedMenu = value),
    );
  }
}
