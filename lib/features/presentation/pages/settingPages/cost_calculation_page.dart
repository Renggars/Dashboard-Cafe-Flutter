// lib/features/pos/presentation/pages/cost_calculation_page.dart
import 'package:flutter/material.dart';

class CostCalculationPage extends StatelessWidget {
  final String type; // Tambahkan parameter type
  const CostCalculationPage({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Jumlah tab: Layanan dan Pajak
      child: Scaffold(
        backgroundColor:
            const Color(0xFFF0F2F5), // Warna background abu-abu muda
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 0, // Sembunyikan AppBar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              alignment: Alignment.centerLeft,
              child: const TabBar(
                isScrollable: true,
                indicatorColor: Color(0xFF3B82F6), // Biru
                labelColor: Color(0xFF3B82F6),
                unselectedLabelColor: Color(0xFF6B7280), // Abu-abu
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Layanan'),
                  Tab(text: 'Pajak'),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: TabBarView(
            children: [
              // Konten untuk Tab 'Layanan'
              _buildCalculationGrid(
                type: 'Layanan',
                items: [
                  {'percentage': '5%', 'name': 'layanan'},
                ],
              ),
              // Konten untuk Tab 'Pajak'
              _buildCalculationGrid(
                type: 'Pajak',
                items: [
                  {'percentage': '11%', 'name': 'PPN'},
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationGrid(
      {required String type, required List<Map<String, String>> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Perhitungan $type',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 24.0,
            mainAxisSpacing: 24.0,
            childAspectRatio: 1.5,
            children: [
              // Kartu untuk menambah perhitungan
              _buildAddCalculationCard(type),
              // Daftar kartu perhitungan yang sudah ada
              ...items.map((item) => _buildCalculationCard(
                    percentage: item['percentage']!,
                    name: item['name']!,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddCalculationCard(String type) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[300]!, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          // Aksi untuk menambah perhitungan baru
          debugPrint('Tambah Perhitungan $type');
        },
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add,
                  size: 48, color: Color(0xFF9CA3AF)), // Abu-abu gelap
              SizedBox(height: 8),
              Text(
                'Tambah Perhitungan',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationCard(
      {required String percentage, required String name}) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBEAFE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit,
                        size: 20, color: Color(0xFF3B82F6)),
                  ),
                ),
                const Spacer(),
                Text(
                  percentage,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nama Promo : $name',
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
