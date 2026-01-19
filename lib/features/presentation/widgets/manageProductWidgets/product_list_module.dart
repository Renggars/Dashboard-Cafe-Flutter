import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cafe/features/pos/data/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProductListModule extends StatefulWidget {
  const ProductListModule({super.key});

  @override
  State<ProductListModule> createState() => _ProductListModuleState();
}

class _ProductListModuleState extends State<ProductListModule> {
  final _service = ProductService();
  List<Map<String, dynamic>> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Ambil Data dari API
  Future<void> _fetchData() async {
    setState(() => _loading = true);
    final data = await _service.getMenus();
    setState(() {
      _products = data;
      _loading = false;
    });
  }

  // Fungsi Hapus dengan Konfirmasi
  Future<void> _handleDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Produk?"),
        content: const Text("Tindakan ini tidak dapat dibatalkan."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? "";
      final success = await _service.deleteProduct(id, token);

      if (success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Produk dihapus")));
        _fetchData(); // Refresh list
      }
    }
  }

  // Fungsi Edit menggunakan Modal Bottom Sheet
  void _showEditModal(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => EditProductDialog(
        product: product,
        onSuccess: () {
          Navigator.pop(context);
          _fetchData();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Card(
        elevation: 2,
        child: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
              columns: const [
                DataColumn(label: Text('Image')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Price')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _products.map((p) {
                return DataRow(cells: [
                  DataCell(
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          "http://10.0.2.2:4001${p['imageUrl']}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                  DataCell(Text(p['name'])),
                  DataCell(Text(p['category']['name'])),
                  DataCell(Text("Rp ${p['price']}")),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditModal(p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _handleDelete(p['id']),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET DIALOG EDIT TERPISAH ---
class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onSuccess;

  const EditProductDialog(
      {super.key, required this.product, required this.onSuccess});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  File? _newImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product['name']);
    _priceController =
        TextEditingController(text: widget.product['price'].toString());
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _newImage = File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Product"),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    image: _newImage != null
                        ? DecorationImage(
                            image: FileImage(_newImage!), fit: BoxFit.cover)
                        : DecorationImage(
                            image: NetworkImage(
                                "http://10.0.2.2:4001${widget.product['imageUrl']}"),
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white70),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Produk"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal")),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleUpdate,
          child: _isSaving
              ? const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Simpan"),
        ),
      ],
    );
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    final success = await ProductService().updateProduct(
      id: widget.product['id'],
      name: _nameController.text,
      price: int.parse(_priceController.text),
      categoryId: widget.product['categoryId'], // Tetap kategori lama
      imageFile: _newImage,
      token: token,
    );

    if (success) widget.onSuccess();
    setState(() => _isSaving = false);
  }
}
