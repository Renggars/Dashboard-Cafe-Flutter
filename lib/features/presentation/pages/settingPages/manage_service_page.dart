import 'package:flutter/material.dart';
import 'package:cafe/features/pos/data/services/setting_service.dart';
import 'package:cafe/injection.dart';

class ManageServicePage extends StatefulWidget {
  const ManageServicePage({super.key});

  @override
  State<ManageServicePage> createState() => _ManageServicePageState();
}

class _ManageServicePageState extends State<ManageServicePage> {
  final SettingService _service = getIt<SettingService>();
  bool _isActive = false;
  bool _isLoading = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final settings = await _service.getGlobalSettings();
      if (mounted) {
        setState(() {
          _isActive = settings.isServiceActive;
          // SINKRONISASI: Paksa value masuk ke controller agar tampil di UI
          if (settings.servicePercentage > 0) {
            _controller.text = settings.servicePercentage.toString();
          } else {
            _controller.clear();
          }
        });
      }
    } catch (e) {
      debugPrint("Error fetching service: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _update() async {
    setState(() => _isLoading = true);
    try {
      final double val = double.tryParse(_controller.text) ?? 0.0;
      await _service.updateGlobalSettings({
        "isServiceActive": _isActive,
        "servicePercentage": val,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Biaya Layanan Berhasil Disimpan"),
              backgroundColor: Colors.green),
        );
        _fetchData(); // Refresh UI
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
                  const Text("Biaya Layanan",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const Text("Service charge untuk pelayanan restoran",
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  _buildSettingCard(
                    icon: Icons.room_service,
                    color: Colors.indigo,
                    title: "Aktifkan Biaya Layanan",
                    child: TextField(
                      controller: _controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Persentase Layanan (%)",
                        hintText: "Contoh: 5",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.percent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoBox(),
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
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        onPressed: _update,
        child: const Text("Simpan Perubahan",
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
              value: _isActive,
              activeColor: color,
              onChanged: (v) => setState(() => _isActive = v)),
        ]),
        const SizedBox(height: 24),
        child,
      ]),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.indigo.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        const Icon(Icons.info_outline, color: Colors.indigo),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "Biaya layanan biasanya digunakan untuk tips staf atau biaya operasional tambahan.",
            style: TextStyle(color: Colors.indigo[800], fontSize: 13),
          ),
        ),
      ]),
    );
  }
}
