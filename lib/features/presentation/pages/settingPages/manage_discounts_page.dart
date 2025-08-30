// lib/features/pos/presentation/pages/manage_discounts_page.dart
import 'package:flutter/material.dart';

class ManageDiscountsPage extends StatelessWidget {
  const ManageDiscountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kelola Diskon',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildDiscountGrid(),
        ],
      ),
    );
  }

  Widget _buildDiscountGrid() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          // Card Tambah Diskon Baru
          _buildAddDiscountCard(),
          _buildDiscountCard(percentage: '20%', name: 'Welcome WCB'),
          _buildDiscountCard(percentage: '10%', name: 'New Year'),
          _buildDiscountCard(percentage: '15%', name: 'Black Friday'),
        ],
      ),
    );
  }

  Widget _buildAddDiscountCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Aksi untuk menambah diskon baru
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 40, color: Colors.grey),
              SizedBox(height: 8),
              Text('Tambah Diskon Baru', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountCard(
      {required String percentage, required String name}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                    onPressed: () {
                      // Aksi edit diskon
                    },
                  ),
                ),
                const Spacer(),
                Text(
                  percentage,
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nama Promo : $name',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
