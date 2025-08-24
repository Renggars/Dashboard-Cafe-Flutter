// lib/features/pos/presentation/pages/sync_data_page.dart
import 'package:flutter/material.dart';

class SyncDataPage extends StatelessWidget {
  const SyncDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5), // Warna background abu-abu muda
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sync Data',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sinkronisasi data dari dan ke server untuk memastikan data Anda selalu up-to-date.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          _buildSyncButton('Sync All Data', Icons.sync),
          const SizedBox(height: 24),
          const Text(
            'Atau pilih data spesifik:',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSmallSyncButton('Sync Product', Icons.inventory_2_outlined),
              const SizedBox(width: 16),
              _buildSmallSyncButton('Sync Order', Icons.shopping_cart_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSyncButton(String label, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Aksi untuk memulai sinkronisasi
          debugPrint('Syncing: $label');
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6), // Warna biru
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallSyncButton(String label, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // Aksi untuk sinkronisasi spesifik
            debugPrint('Syncing: $label');
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Column(
              children: [
                Icon(icon, color: const Color(0xFF3B82F6), size: 24),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
