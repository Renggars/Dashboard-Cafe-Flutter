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

  final Color primaryBlue = const Color(0xFF0061FF);

  Future<void> _handleCreate() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama kategori tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    final success = await _service.createCategory(_nameController.text, token);

    if (success) {
      _nameController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Kategori berhasil ditambahkan"),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(32.0),
      color: const Color(0xFFF8FAFC), // Background abu-abu sangat muda
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Page
          const Text(
            "Create New Category",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tambahkan kategori baru untuk mengelompokkan menu Anda",
            style: TextStyle(fontSize: 16, color: Colors.blueGrey),
          ),
          const SizedBox(height: 48),

          // Centralized Form
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.category_rounded,
                          color: primaryBlue, size: 40),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Detail Kategori",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),

                    // Input Field
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        labelText: "Nama Kategori",
                        hintText: "Contoh: Makanan Berat, Coffee, Drink",
                        prefixIcon:
                            Icon(Icons.edit_note_rounded, color: primaryBlue),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: primaryBlue, width: 2),
                        ),
                        floatingLabelStyle: TextStyle(
                            color: primaryBlue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Action Button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleCreate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save_rounded),
                                  SizedBox(width: 12),
                                  Text(
                                    "Simpan Kategori",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
