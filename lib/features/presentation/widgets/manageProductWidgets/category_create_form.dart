import 'package:cafe/features/pos/data/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryCreateForm extends StatefulWidget {
  const CategoryCreateForm({super.key});

  @override
  State<CategoryCreateForm> createState() => _CategoryCreateFormState();
}

class _CategoryCreateFormState extends State<CategoryCreateForm> {
  final _service = CategoryService();
  final _nameController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _handleCreate() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isSubmitting = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    final success = await _service.createCategory(_nameController.text, token);

    if (success) {
      _nameController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kategori berhasil ditambahkan")),
        );
      }
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Create Category",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Nama Kategori (Contoh: Makanan Berat)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _handleCreate,
                    icon: const Icon(Icons.add),
                    label: Text(_isSubmitting ? "Saving..." : "Save Category"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
