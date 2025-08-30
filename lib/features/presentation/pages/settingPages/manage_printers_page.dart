// lib/features/pos/presentation/pages/manage_printers_page.dart
import 'package:cafe/core/constants/colors.dart';
import 'package:flutter/material.dart';

class ManagePrintersPage extends StatefulWidget {
  const ManagePrintersPage({super.key});

  @override
  State<ManagePrintersPage> createState() => _ManagePrintersPageState();
}

class _ManagePrintersPageState extends State<ManagePrintersPage> {
  String _selectedSize = '80 mm'; // State untuk ukuran yang dipilih
  final List<String> _connectedPrinters = [
    'Printer XYZ',
    'Printer ABC'
  ]; // Contoh data printer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Printer Management',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () {
            // Aksi kembali
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Ukuran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSizeSelection(),
            const SizedBox(height: 32),
            const Text(
              'Pilih Printer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPrinterButtons(),
            const SizedBox(height: 24),
            _buildPrinterList(),
            const Spacer(),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelection() {
    return Row(
      children: [
        _buildSizeCard('58 mm'),
        const SizedBox(width: 16),
        _buildSizeCard('80 mm'),
      ],
    );
  }

  Widget _buildSizeCard(String size) {
    bool isSelected = _selectedSize == size;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSize = size;
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Card(
          elevation: isSelected ? 4 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isSelected
                ? const BorderSide(color: Color(0xFF3B82F6), width: 2)
                : BorderSide.none,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            alignment: Alignment.center,
            child: Text(
              size,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF3B82F6) : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrinterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(
          label: 'Search',
          icon: Icons.search,
          onTap: () {
            // Aksi untuk mencari printer
            debugPrint('Searching for printers...');
            // Contoh: Tambah printer baru ke daftar
            setState(() {
              _connectedPrinters.add('New Found Printer');
            });
          },
        ),
        _buildActionButton(
          label: 'Disconnect',
          icon: Icons.power_off,
          onTap: () {
            // Aksi untuk memutuskan koneksi printer
            debugPrint('Disconnecting printer...');
          },
        ),
        _buildActionButton(
          label: 'Test',
          icon: Icons.print_outlined,
          onTap: () {
            // Aksi untuk mencoba tes print
            debugPrint('Testing printer...');
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      {required String label,
      required IconData icon,
      required VoidCallback onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF4B5563)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrinterList() {
    if (_connectedPrinters.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16, color: Colors.black45),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _connectedPrinters.length,
        itemBuilder: (context, index) {
          final printerName = _connectedPrinters[index];
          return Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                printerName,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () {
                  // Aksi untuk menghapus printer dari daftar
                  setState(() {
                    _connectedPrinters.removeAt(index);
                  });
                  debugPrint('Removing printer: $printerName');
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Aksi untuk menyimpan konfigurasi
          debugPrint('Saving printer configuration...');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Warna hijau
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
