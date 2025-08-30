// lib/features/pos/presentation/pages/paid_order_page.dart

import 'package:flutter/material.dart';
import 'package:cafe/core/constants/colors.dart';

class PaidOrderPage extends StatelessWidget {
  const PaidOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data untuk tampilan
    final List<dynamic> paidOrders = [
      {'name': 'Ais TEST 100', 'items': '1x Rp. 100', 'price': 100},
      {'name': 'Paket Test', 'items': '1x Rp. 100', 'price': 100},
      {'name': 'Paket Hemat', 'items': '2x Rp. 100', 'price': 200},
      {'name': 'Minuman Segar', 'items': '1x Rp. 100', 'price': 100},
      {'name': 'Cemilan', 'items': '1x Rp. 100', 'price': 100},
      {'name': 'Kopi Susu', 'items': '1x Rp. 45.100', 'price': 45100},
    ];

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FB),
      appBar: AppBar(
        title: const Text('Paid Order - Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: paidOrders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = paidOrders[index];
          return Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: ExpansionTile(
              tilePadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: const Icon(Icons.qr_code, color: AppColors.primary),
              title: const Text('PAID - QRIS',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(
                'Rp. ${order['price']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          Text('Rp. ${order['price']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order['items'],
                              style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Print Receipt'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Print Kitchen'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
