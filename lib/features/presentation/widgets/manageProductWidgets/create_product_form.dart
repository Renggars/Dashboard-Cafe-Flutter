import 'dart:io';
import 'package:cafe/features/pos/data/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini
import 'package:cafe/features/pos/data/services/product_service.dart'; // Sesuaikan path

class CreateProductForm extends StatefulWidget {
  const CreateProductForm({super.key});

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _productService = ProductService(); // Inisialisasi Service
  final _categoryService = CategoryService();

  File? _image;
  bool _isLoading = false;
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await _categoryService.getCategories();
    setState(() => _categories = data);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Silahkan pilih gambar")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // AMBIL TOKEN DARI STORAGE
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sesi habis, silahkan login ulang")));
        return;
      }

      final success = await _productService.createProduct(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        categoryId: int.parse(_selectedCategoryId ?? "1"),
        imageFile: _image,
        token: token,
      );

      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil ditambahkan!")));
        _nameController.clear();
        _priceController.clear();
        setState(() {
          _image = null;
          _selectedCategoryId = null;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal menambahkan produk")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Add New Product",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          // Berubah warna jadi Teal jika gambar sudah ada
                          color:
                              _image != null ? Colors.teal : Colors.grey[400]!,
                          width: 2,
                        ),
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _image == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined,
                                    size: 50, color: Colors.grey[600]),
                                const SizedBox(height: 8),
                                const Text(
                                    "Klik untuk pilih gambar dari galeri"),
                              ],
                            )
                          : Stack(
                              // Gunakan Positioned (bukan Green) untuk tombol hapus
                              children: [
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _image = null),
                                    child: const CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close,
                                          size: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder()),
                    validator: (v) => v!.isEmpty ? "Nama wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                        labelText: "Price", border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    isExpanded: true,
                    hint: const Text(
                        "Pilih Kategori"), // Muncul saat belum ada yang dipilih
                    decoration: const InputDecoration(
                        labelText: "Category", border: OutlineInputBorder()),
                    // Cek apakah list categories sudah terisi
                    items: _categories.map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat['id'].toString(),
                        child: Text(cat['name']),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCategoryId = val;
                      });
                    },
                    validator: (v) =>
                        v == null ? "Kategori tidak boleh kosong" : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _submit,
                            child: const Text("Create Product")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
