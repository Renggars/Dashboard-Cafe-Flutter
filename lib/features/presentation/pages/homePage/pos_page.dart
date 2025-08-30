// lib/features/pos/presentation/pages/pos_page.dart
// import 'package:cafe/features/presentation/pages/manage_products_page.dart';
import 'package:cafe/features/presentation/pages/homePage/paid_order_page.dart';
import 'package:cafe/features/presentation/pages/reportPage/report_page.dart';
import 'package:cafe/features/presentation/pages/settingPages/settings_page.dart';
import 'package:cafe/features/presentation/widgets/homeWidgets/order_panel.dart';
import 'package:cafe/features/presentation/widgets/homeWidgets/pos_sidebar.dart';
import 'package:cafe/features/presentation/widgets/homeWidgets/product_grid_section.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          flex: 2,
          child: ProductGridSection(),
        ),
        Expanded(
          flex: 1,
          child: OrderPanel(),
        ),
      ],
    );
  }
}

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  // State untuk menyimpan index halaman yang aktif
  int _activeIndex = 0;

  // Daftar semua halaman/konten utama
  final List<Widget> _pages = [
    const HomePage(), // Index 0
    // const ManageProductsPage(), // Index 2
    const PaidOrderPage(), // Index 1
    const ReportPage(), // Index 3
    const SettingsPage(), // Index 4
  ];

  // Fungsi untuk mengubah halaman
  void _onMenuTapped(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          PosSidebar(
            onMenuTapped: _onMenuTapped,
          ),
          Expanded(
            child: _pages[_activeIndex],
          ),
        ],
      ),
    );
  }
}
