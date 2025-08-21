import 'package:flutter/material.dart';
import 'package:cafe/core/constants/colors.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      color: AppColors.primary,
      child: Column(
        children: [
          const SizedBox(height: 14),
          _buildSidebarItem(Icons.home, isSelected: true),
          _buildSidebarItem(Icons.receipt_long),
          _buildSidebarItem(Icons.inventory_2),
          const Spacer(),
          _buildSidebarItem(Icons.logout),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.white, size: 40),
    );
  }
}
