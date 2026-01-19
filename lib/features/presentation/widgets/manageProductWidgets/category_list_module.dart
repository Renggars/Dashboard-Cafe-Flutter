import 'package:cafe/features/pos/data/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryListModule extends StatefulWidget {
  const CategoryListModule({super.key});

  @override
  State<CategoryListModule> createState() => _CategoryListModuleState();
}

class _CategoryListModuleState extends State<CategoryListModule> {
  final _service = CategoryService();
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    final data = await _service.getCategories();
    setState(() {
      _categories = data;
      _isLoading = false;
    });
  }

  Future<void> _handleDelete(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? "";

    // Tampilkan konfirmasi
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Kategori?"),
        content: const Text(
            "Menghapus kategori mungkin mempengaruhi data menu terkait."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Batal")),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.deleteCategory(id, token);
      if (success) {
        _fetchCategories();
        if (mounted)
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Kategori dihapus")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Category List",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: Scrollbar(
                // Tambahkan scrollbar agar user tahu bisa di-scroll
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical, // Scroll atas bawah
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // Scroll kiri kanan
                    child: SizedBox(
                      // Gunakan SizedBox untuk memaksakan lebar minimal jika ingin full
                      width: MediaQuery.of(context).size.width - 80,
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Category Name')),
                          DataColumn(label: Text('Total Products')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: _categories.map((cat) {
                          List menus = cat['menus'] ?? [];
                          return DataRow(cells: [
                            DataCell(Text(cat['id'].toString())),
                            DataCell(Text(cat['name'].toUpperCase())),
                            DataCell(Text("${menus.length} Items")),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.orange),
                                  onPressed: () => _showEditDialog(cat),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () => _handleDelete(cat['id']),
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> cat) {
    final controller = TextEditingController(text: cat['name']);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Category"),
        content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Nama Kategori")),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final success = await _service.updateCategory(
                  cat['id'], controller.text, prefs.getString('token') ?? "");
              if (success) {
                Navigator.pop(ctx);
                _fetchCategories();
              }
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }
}
