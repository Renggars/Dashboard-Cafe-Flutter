import 'package:cafe/features/pos/data/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

class CategoryListModule extends StatefulWidget {
  const CategoryListModule({super.key});

  @override
  State<CategoryListModule> createState() => _CategoryListModuleState();
}

class _CategoryListModuleState extends State<CategoryListModule> {
  final _service = CategoryService();
  List<dynamic> _allCategories = [];
  List<dynamic> _filteredCategories = [];
  bool _isLoading = true;
  String _searchQuery = "";

  final Color primaryBlue = const Color(0xFF0061FF);
  final Color surfaceColor = const Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getCategories();
      setState(() {
        _allCategories = data;
        _filteredCategories = data;
        _isLoading = false;
      });
    } catch (e) {
      dev.log("Error fetch categories: $e");
      setState(() => _isLoading = false);
    }
  }

  void _filterCategories(String query) {
    setState(() {
      _searchQuery = query;
      _filteredCategories = _allCategories
          .where((cat) => cat['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  // --- UI COMPONENTS ---

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        color: surfaceColor,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildSearchAndFilterRow(),
            const SizedBox(height: 24),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(color: primaryBlue))
                  : _buildModernTable(constraints.maxWidth),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(Icons.category_rounded, color: primaryBlue, size: 32),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manajemen Kategori",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              "Total ${_allCategories.length} kategori terdaftar",
              style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
            ),
          ],
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: _fetchCategories,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text("Refresh Data"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterRow() {
    return Container(
      width: 500, // Lebar ideal untuk tablet agar tidak memenuhi layar
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: TextField(
        onChanged: _filterCategories,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
          hintText: "Cari nama kategori...",
          prefixIcon: Icon(Icons.search_rounded, color: primaryBlue, size: 28),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        ),
      ),
    );
  }

  Widget _buildModernTable(double maxWidth) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SingleChildScrollView(
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(const Color(0xFFF1F5F9)),
            dataRowMaxHeight: 90,
            headingRowHeight: 75,
            horizontalMargin: 32,
            columnSpacing: 40,
            columns: [
              const DataColumn(
                  label: Text('ID',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              const DataColumn(
                  label: Text('NAMA KATEGORI',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              const DataColumn(
                  label: Text('JUMLAH MENU',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
              const DataColumn(
                  label: Text('AKSI',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16))),
            ],
            rows: _filteredCategories.map((cat) {
              final int menuCount = (cat['menus'] as List?)?.length ?? 0;
              return DataRow(cells: [
                DataCell(Text("#${cat['id']}",
                    style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 16))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: primaryBlue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cat['name'].toString().toUpperCase(),
                      style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 1.1),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Text("$menuCount Produk",
                          style: const TextStyle(
                              fontSize: 18, color: Color(0xFF334155))),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      _buildActionBtn(Icons.edit_note_rounded, Colors.orange,
                          () => _showEditDialog(cat)),
                      const SizedBox(width: 16),
                      _buildActionBtn(Icons.delete_sweep_rounded, Colors.red,
                          () => _handleDelete(cat['id'])),
                    ],
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: color, size: 28),
        ),
      ),
    );
  }

  // --- LOGIC HANDLERS (SAMA DENGAN KODE ANDA TAPI DENGAN PENYEMPURNAAN UI DIALOG) ---

  void _showEditDialog(Map<String, dynamic> cat) {
    final controller = TextEditingController(text: cat['name']);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Perbarui Kategori",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(fontSize: 20),
            decoration: InputDecoration(
              labelText: "Nama Kategori Baru",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none),
              prefixIcon: const Icon(Icons.edit_rounded),
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.all(20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal",
                style: TextStyle(fontSize: 18, color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final success = await _service.updateCategory(
                  cat['id'], controller.text, prefs.getString('token') ?? "");
              if (success && mounted) {
                Navigator.pop(ctx);
                _fetchCategories();
              }
            },
            child: const Text("Simpan Perubahan",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
    );
  }

  Future<void> _handleDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
            SizedBox(width: 12),
            Text("Konfirmasi Hapus"),
          ],
        ),
        content: const Text(
            "Kategori ini akan dihapus secara permanen. Lanjutkan?",
            style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text("Ya, Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final prefs = await SharedPreferences.getInstance();
      final success =
          await _service.deleteCategory(id, prefs.getString('token') ?? "");
      if (success) {
        _fetchCategories();
      }
    }
  }
}
