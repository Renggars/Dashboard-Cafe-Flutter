import 'package:flutter/material.dart';
import 'package:cafe/core/constants/colors.dart'; // Pastikan path ini benar

class PosSidebar extends StatefulWidget {
  final void Function(int index) onMenuTapped;

  const PosSidebar({
    super.key,
    required this.onMenuTapped,
  });

  @override
  State<PosSidebar> createState() => _PosSidebarState();
}

class _PosSidebarState extends State<PosSidebar> {
  // State untuk melacak item menu yang sedang aktif
  int _selectedIndex = 0;

  // Data untuk item menu, membuatnya mudah untuk ditambah/diubah
  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.home_outlined, 'notification': 0},
    {'icon': Icons.production_quantity_limits, 'notification': 0},
    {'icon': Icons.receipt_long_outlined, 'notification': 31},
    {'icon': Icons.bar_chart_outlined, 'notification': 0},
    {'icon': Icons.settings_outlined, 'notification': 0},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: AppColors.primary,
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Placeholder untuk logo
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Icon(
              Icons.network_check_rounded, // Ganti dengan logo Anda
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 14),
          // Membuat daftar menu secara dinamis
          ..._menuItems.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            return _buildMenuItem(
              icon: item['icon'],
              index: index,
              notificationCount: item['notification'],
            );
          }),
          const Spacer(), // Mendorong item logout ke bawah
          _buildMenuItem(
            icon: Icons.logout_outlined,
            index: _menuItems.length, // Indeks unik untuk logout
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget untuk setiap item menu
  Widget _buildMenuItem({
    required IconData icon,
    required int index,
    int notificationCount = 0,
  }) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onMenuTapped(index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(child: Icon(icon, color: AppColors.white, size: 40)),
            if (notificationCount > 0)
              _buildNotificationBadge(notificationCount),
          ],
        ),
      ),
    );
  }

  // Widget untuk badge notifikasi
  Widget _buildNotificationBadge(int count) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 2)),
        constraints: const BoxConstraints(
          minWidth: 22,
          minHeight: 22,
        ),
        child: Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
