import 'dart:io';
import 'package:cafe/features/pos/data/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cafe/features/pos/data/services/product_service.dart';

class CreateProductForm extends StatefulWidget {
  const CreateProductForm({super.key});

  @override
  State<CreateProductForm> createState() => _CreateProductFormState();
}

class _CreateProductFormState extends State<CreateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _productService = ProductService();
  final _categoryService = CategoryService();

  File? _image;
  bool _isLoading = false;
  List<Map<String, dynamic>> _categories = [];
  String? _selectedCategoryId;

  // Palette warna yang konsisten
  final Color primaryBlue = const Color(0xFF0061FF);
  final Color inputFillColor = const Color(0xFFF8F9FB);

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
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pilih gambar produk terlebih dahulu")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) return;

      final success = await _productService.createProduct(
        name: _nameController.text,
        price: int.parse(_priceController.text),
        categoryId: int.parse(_selectedCategoryId ?? "1"),
        imageFile: _image,
        token: token,
      );

      if (success) {
        if (!mounted) return;
        _nameController.clear();
        _priceController.clear();
        setState(() {
          _image = null;
          _selectedCategoryId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Produk berhasil ditambahkan!")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      alignment: Alignment.topLeft,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header Ringkas
              Text("Detail Produk Baru",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800)),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sisi Kiri: Foto (Dikecilkan sedikit dari versi sebelumnya)
                  Expanded(
                    flex: 3,
                    child: _buildImageSection(),
                  ),
                  const SizedBox(width: 40),
                  // Sisi Kanan: Input Form
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildInputField(
                          controller: _nameController,
                          label: "Nama Produk",
                          hint: "Masukkan nama menu",
                          icon: Icons.drive_file_rename_outline_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _priceController,
                          label: "Harga Jual",
                          hint: "0",
                          icon: Icons.payments_rounded,
                          isNumber: true,
                        ),
                        const SizedBox(height: 20),
                        _buildCategoryDropdown(),
                        const SizedBox(height: 40),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Foto Produk",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 320, // Ketinggian yang pas untuk proporsi tablet
            width: double.infinity,
            decoration: BoxDecoration(
              color: inputFillColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200, width: 2),
            ),
            child: _image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 60, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text("Tambah Foto",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 16)),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(_image!, fit: BoxFit.cover),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => setState(() => _image = null),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          inputFormatters:
              isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: primaryBlue, size: 24),
            filled: true,
            fillColor: inputFillColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  BorderSide(color: primaryBlue.withOpacity(0.5), width: 2),
            ),
          ),
          validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kategori Produk",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(16),
            // Menambahkan shadow halus agar dropdown terlihat memiliki dimensi
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategoryId,
            isExpanded: true,
            dropdownColor: Colors.white,
            borderRadius:
                BorderRadius.circular(16), // Border radius menu yang terbuka
            icon: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.expand_more_rounded, color: primaryBlue, size: 22),
            ),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
            // Menghilangkan underline default karena kita pakai dekorasi container
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.grid_view_rounded, color: primaryBlue, size: 24),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              border: InputBorder.none, // Hilangkan border bawaan
              hintText: "Pilih kategori...",
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 17),
            ),
            // Kustomisasi tampilan item saat dipilih (Selected State)
            selectedItemBuilder: (BuildContext context) {
              return _categories.map<Widget>((cat) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    cat['name'],
                    style: TextStyle(
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList();
            },
            // Tampilan daftar menu saat dibuka
            items: _categories.map((cat) {
              return DropdownMenuItem<String>(
                value: cat['id'].toString(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.label_important_outline_rounded,
                          size: 20, color: Colors.grey.shade400),
                      const SizedBox(width: 12),
                      Text(cat['name']),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (val) => setState(() => _selectedCategoryId = val),
            validator: (v) => v == null ? "Pilih kategori" : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 70, // Dikecilkan dari 90 ke 70 agar proporsional
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("SIMPAN PRODUK",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1)),
      ),
    );
  }
}
