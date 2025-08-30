import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  String selectedMenu = "create"; // 'create', 'edit', 'delete'
  Map<String, dynamic>? _selectedProductForEdit;

  // Dummy data
  final List<Map<String, dynamic>> _products = List.generate(
    8,
    (index) => {
      "id": index,
      "name": "Produk ${index + 1}",
      "price": (index + 1) * 15000,
      "category": "Makanan",
      "imageUrl": "https://via.placeholder.com/150/92c952", // Placeholder image
    },
  );

  void _selectProductForEdit(Map<String, dynamic> product) {
    setState(() {
      _selectedProductForEdit = product;
    });
  }

  void _clearEditSelection() {
    setState(() {
      _selectedProductForEdit = null;
    });
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

  // ===========================================================================
  // ============================== Sidebar ====================================
  // ===========================================================================
  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Icon(Icons.storefront, color: Colors.deepPurple, size: 32),
                const SizedBox(width: 12),
                const Text(
                  "Product Panel",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildSidebarItem(
              "Create Product", Icons.add_circle_outline, "create"),
          _buildSidebarItem("Edit Product", Icons.edit_outlined, "edit"),
          _buildSidebarItem(
              "Delete Product", Icons.delete_outline_rounded, "delete"),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String label, IconData icon, String value) {
    final bool isSelected = selectedMenu == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenu = value;
          // JIKA menu 'edit' diklik DAN daftar produk tidak kosong
          if (value == 'edit' && _products.isNotEmpty) {
            // Langsung pilih produk pertama untuk diedit
            _selectProductForEdit(_products.first);
          } else {
            // Jika menu lain (create/delete), kosongkan pilihan
            _clearEditSelection();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected ? Colors.deepPurple : Colors.grey.shade600),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.deepPurple : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // ========================== Content Area ===================================
  // ===========================================================================
  Widget _buildContent() {
    switch (selectedMenu) {
      case "create":
        return _buildCreateSection();
      case "edit":
      case "delete":
        return _buildManageSection();
      default:
        return const Center(child: Text("Halaman tidak ditemukan"));
    }
  }

  Widget _buildCreateSection() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _ProductForm(
          key: const ValueKey('create_form'), // Key untuk membedakan form
          onSave: (name, price) {
            // TODO: Implementasi logika create product
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Produk '$name' berhasil dibuat!")),
            );
          },
        ),
      ),
    );
  }

  Widget _buildManageSection() {
    return Row(
      children: [
        // Kolom 2: Daftar Produk
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedMenu == 'edit'
                      ? "Select a product to edit"
                      : "Select a product to delete",
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildProductGrid(
                    isEditMode: selectedMenu == 'edit',
                  ),
                ),
              ],
            ),
          ),
        ),
        // Kolom 3: Form Edit (muncul tanpa animasi jika menu 'edit')
        if (selectedMenu == 'edit' && _selectedProductForEdit != null)
          Container(
            width: 350,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(left: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: _ProductForm(
              key: ValueKey(_selectedProductForEdit![
                  'id']), // Key unik agar form di-rebuild
              initialProduct: _selectedProductForEdit,
              onSave: (name, price) {
                // TODO: Implementasi logika update product
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Produk '$name' berhasil diupdate!")),
                );
                _clearEditSelection();
              },
              onClose: _clearEditSelection,
            ),
          ),
      ],
    );
  }

  Widget _buildProductGrid({required bool isEditMode}) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 8),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final bool isSelected = _selectedProductForEdit?['id'] == product['id'];

        return InkWell(
          onTap: () {
            if (isEditMode) {
              _selectProductForEdit(product);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
                width: isSelected ? 2.0 : 1.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(Icons.fastfood,
                          size: 60, color: Colors.deepPurple.shade100),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product["name"].toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(
                            locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0)
                        .format(product["price"]),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: isEditMode
                        ? ElevatedButton(
                            onPressed: () => _selectProductForEdit(product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected
                                  ? Colors.deepPurple
                                  : Colors.deepPurple.shade50,
                              foregroundColor:
                                  isSelected ? Colors.white : Colors.deepPurple,
                              elevation: 0,
                            ),
                            child: const Text("Edit"),
                          )
                        : ElevatedButton(
                            onPressed: () => _confirmDelete(
                                context, product["name"].toString()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red.shade800,
                              elevation: 0,
                            ),
                            child: const Text("Delete"),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // ============================ Dialog Konfirmasi ============================
  // ===========================================================================
  void _confirmDelete(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content:
            Text("Apakah Anda yakin ingin menghapus produk '$productName'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: implementasi logika delete
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Produk '$productName' berhasil dihapus!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// ========================= Widget Form Terpisah ============================
// ===========================================================================
class _ProductForm extends StatefulWidget {
  final Map<String, dynamic>? initialProduct;
  final Function(String name, int price) onSave;
  final VoidCallback? onClose;

  const _ProductForm({
    super.key,
    this.initialProduct,
    required this.onSave,
    this.onClose,
  });

  @override
  State<_ProductForm> createState() => __ProductFormState();
}

class __ProductFormState extends State<_ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  bool get isEditMode => widget.initialProduct != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialProduct?['name'] ?? '');
    _priceController = TextEditingController(
        text: widget.initialProduct?['price']?.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant _ProductForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Perbarui controller jika produk yang diedit berubah
    if (widget.initialProduct != oldWidget.initialProduct) {
      _nameController.text = widget.initialProduct?['name'] ?? '';
      _priceController.text = widget.initialProduct?['price']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text,
        int.tryParse(_priceController.text) ?? 0,
      );
      if (!isEditMode) {
        _formKey.currentState!.reset();
        _nameController.clear();
        _priceController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditMode ? "Edit Product" : "Create New Product",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                if (isEditMode && widget.onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Product Name",
                border: OutlineInputBorder(),
              ),
              validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                prefixText: "Rp ",
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v!.isEmpty) return 'Harga tidak boleh kosong';
                if (int.tryParse(v) == null) return 'Masukkan angka yang valid';
                return null;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(isEditMode ? Icons.save_as : Icons.add),
                label: Text(isEditMode ? "Update Product" : "Save Product"),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
