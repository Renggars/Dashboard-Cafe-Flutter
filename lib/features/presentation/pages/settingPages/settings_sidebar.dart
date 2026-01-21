// lib/features/pos/presentation/widgets/settings_sidebar.dart
import 'package:flutter/material.dart';

class SettingsSidebar extends StatelessWidget {
  final int activeIndex;
  final Function(int) onMenuTapped;

  const SettingsSidebar({
    super.key,
    required this.activeIndex,
    required this.onMenuTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),

          // INDEX 0
          _buildMenuItem(
            icon: Icons.percent,
            label: 'Kelola Diskon',
            subtitle: 'Atur diskon global',
            index: 0,
          ),

          // INDEX 1
          _buildMenuItem(
            icon: Icons.room_service,
            label: 'Biaya Layanan',
            subtitle: 'Atur service charge',
            index: 1,
          ),

          // INDEX 2
          _buildMenuItem(
            icon: Icons.receipt_long,
            label: 'Pajak (PB1)',
            subtitle: 'Atur pajak restoran',
            index: 2,
          ),

          // INDEX 3
          _buildMenuItem(
            icon: Icons.print,
            label: 'Kelola Printer',
            subtitle: 'Atur printer struk & dapur',
            index: 3,
          ),

          // INDEX 4
          _buildMenuItem(
            icon: Icons.sync,
            label: 'Sync Data',
            subtitle: 'Sinkronisasi data server',
            index: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required int index,
  }) {
    final isSelected = activeIndex == index;
    return InkWell(
      onTap: () => onMenuTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey[700],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
