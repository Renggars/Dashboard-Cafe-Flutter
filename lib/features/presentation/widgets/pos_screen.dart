import 'package:flutter/material.dart';
import 'package:cafe/features/presentation/widgets/order_panel.dart';
import 'package:cafe/features/presentation/widgets/product_grid_section.dart';
import 'package:cafe/features/presentation/widgets/sidebar.dart';

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // Sidebar (Panel Kiri)
        Sidebar(),

        // Product Grid Section (Panel Tengah)
        Expanded(
          flex: 2, // Mengambil porsi 2/3 dari sisa layar
          child: ProductGridSection(),
        ),

        // Order Panel (Panel Kanan)
        Expanded(
          flex: 1, // Mengambil porsi 1/3 dari sisa layar
          child: OrderPanel(),
        ),
      ],
    );
  }
}
