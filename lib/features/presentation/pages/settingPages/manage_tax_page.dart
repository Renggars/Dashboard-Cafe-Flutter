import 'package:flutter/material.dart';
import 'package:cafe/features/pos/data/services/setting_service.dart';
import 'package:cafe/injection.dart';

class ManageTaxPage extends StatefulWidget {
  const ManageTaxPage({super.key});

  @override
  State<ManageTaxPage> createState() => _ManageTaxPageState();
}

class _ManageTaxPageState extends State<ManageTaxPage> {
  final SettingService _service = getIt<SettingService>();

  bool _isActive = false;
  bool _isLoading = false;
  // Controller harus diupdate teksnya saat fetch data
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final settings = await _service.getGlobalSettings();

      setState(() {
        // 1. Update State Toggle
        _isActive = settings.isTaxActive;

        // 2. SINKRONISASI INPUT: Masukkan angka ke controller
        // Gunakan toString() agar angka 5 muncul sebagai teks "5"
        if (settings.taxPercentage != null && settings.taxPercentage != 0) {
          _controller.text = settings.taxPercentage.toString();
        } else {
          _controller.clear();
        }
      });
    } catch (e) {
      debugPrint("Error fetching tax: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      await _service.updateGlobalSettings({
        "isTaxActive": _isActive,
        "taxPercentage": double.tryParse(_controller.text) ?? 0.0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Pajak berhasil diperbarui"),
              backgroundColor: Colors.green),
        );
        _fetchInitialData(); // Refresh kembali untuk memastikan UI & DB sama
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Atur Pajak",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text("Pajak Pertambahan Nilai (PPN/PB1)",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  _buildSettingCard(
                    icon: Icons.receipt_long,
                    color: Colors.blue,
                    title: "Aktifkan Pajak (PPN)",
                    child: TextField(
                      controller: _controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Persentase Pajak (%)",
                        hintText: "Contoh: 11",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.percent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        onPressed: _save,
        child: const Text("Simpan Konfigurasi",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSettingCard(
      {required IconData icon,
      required Color color,
      required String title,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ]),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color)),
            const SizedBox(width: 16),
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
          Switch.adaptive(
            value: _isActive, // Nilai ini sekarang mengikuti hasil fetch
            activeColor: color,
            onChanged: (v) => setState(() => _isActive = v),
          ),
        ]),
        const SizedBox(height: 24),
        child,
      ]),
    );
  }
}
