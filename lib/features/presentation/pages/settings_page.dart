// lib/features/pos/presentation/pages/settings_page.dart
import 'package:cafe/features/presentation/pages/manage_discounts_page.dart';
import 'package:cafe/features/presentation/pages/manage_printers_page.dart';
import 'package:cafe/features/presentation/pages/cost_calculation_page.dart';
import 'package:cafe/features/presentation/pages/sync_data_page.dart';
import 'package:cafe/features/presentation/widgets/settings_sidebar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State untuk menyimpan index halaman pengaturan yang aktif
  int _activeIndex = 0;

  // Daftar semua halaman/konten pengaturan
  final List<Widget> _settingPages = [
    const ManageDiscountsPage(),
    const ManagePrintersPage(),
    const CostCalculationPage(),
    const SyncDataPage(),
  ];

  // Fungsi untuk mengubah halaman pengaturan
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
          SettingsSidebar(
            activeIndex: _activeIndex,
            onMenuTapped: _onMenuTapped,
          ),
          Expanded(
            flex: 4,
            child: _settingPages[_activeIndex],
          ),
        ],
      ),
    );
  }
}
