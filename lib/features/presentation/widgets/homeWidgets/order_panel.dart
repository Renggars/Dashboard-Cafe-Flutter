// lib/features/pos/presentation/widgets/order_panel.dart
import 'package:cafe/features/pos/logic/order_bloc/order_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_event.dart';

class OrderPanel extends StatelessWidget {
  const OrderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(24),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          double subTotal =
              state.orderItems.fold(0, (sum, item) => sum + item.totalPrice);
          // Asumsi nilai tetap untuk demo
          const double serviceFeePercentage = 0.05; // 5%
          const double taxPercentage = 0.10; // 10%
          const double discountAmount = 0; // Asumsi diskon Rp 0

          double serviceFee = subTotal * serviceFeePercentage;
          double tax = subTotal * taxPercentage;
          double grandTotal = subTotal + serviceFee + tax - discountAmount;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Orders #',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Item',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Qty',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Price',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              Expanded(
                child: state.orderItems.isEmpty
                    ? const Center(
                        child: Text(
                          'No orders yet',
                          style: TextStyle(color: AppColors.fontGrey),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.orderItems.length,
                        itemBuilder: (context, index) {
                          return OrderListItem(item: state.orderItems[index]);
                        },
                      ),
              ),
              const SizedBox(height: 20),
              _buildServiceFeeOptions(),
              const SizedBox(height: 20),
              _buildTransactionSummary(
                subTotal: subTotal,
                serviceFee: serviceFee,
                tax: tax,
                discount: discountAmount,
                grandTotal: grandTotal,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan Pembayaran',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildServiceFeeOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildFeeOptionCard(
          icon: Icons.discount,
          label: 'Diskon',
          onTap: () {
            // Aksi untuk menerapkan diskon
          },
        ),
        _buildFeeOptionCard(
          icon: Icons.percent,
          label: 'Pajak PB1',
          onTap: () {
            // Aksi untuk menerapkan pajak
          },
        ),
        _buildFeeOptionCard(
          icon: Icons.room_service,
          label: 'Layanan',
          onTap: () {
            // Aksi untuk menerapkan biaya layanan
          },
        ),
      ],
    );
  }

  Widget _buildFeeOptionCard(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: Card(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            )),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primary, size: 28),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.fontGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSummary({
    required double subTotal,
    required double serviceFee,
    required double tax,
    required double discount,
    required double grandTotal,
  }) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );

    return Column(
      children: [
        _buildSummaryRow(
            'Pajak PB1',
            '${(tax / subTotal * 100).toStringAsFixed(0)} %',
            formatCurrency.format(tax)),
        _buildSummaryRow(
            'Layanan',
            '${(serviceFee / subTotal * 100).toStringAsFixed(0)} %',
            formatCurrency.format(serviceFee)),
        _buildSummaryRow('Diskon', '', formatCurrency.format(discount)),
        const Divider(thickness: 1, height: 20),
        _buildSummaryRow('Sub total', '', formatCurrency.format(grandTotal),
            isBold: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String percentage, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppColors.primary : AppColors.fontGrey,
            ),
          ),
          Text(
            percentage,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.fontGrey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? AppColors.primary : AppColors.fontGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// Class OrderListItem dan AppColors tetap sama seperti sebelumnya
class OrderListItem extends StatelessWidget {
  final OrderItem item;
  const OrderListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatCurrency.format(item.product.price),
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColors.fontGrey,
                  ),
                ),
              ],
            ),
          ),

          // Tengah (Quantity Selector)
          _buildQuantitySelector(context, item),
          const SizedBox(width: 30),

          // Kanan (Total Price)
          SizedBox(
            width: 120,
            child: Text(
              formatCurrency.format(item.totalPrice),
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, OrderItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors
            .grey[100], // ⬅️ putih agak abu biar beda dari background utama
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[300]!, // border tipis biar lebih jelas
          width: 1,
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16, color: AppColors.primary),
            onPressed: () {
              context.read<OrderBloc>().add(DecrementOrderItem(item));
            },
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
          Text(
            item.quantity.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16, color: AppColors.primary),
            onPressed: () {
              context.read<OrderBloc>().add(IncrementOrderItem(item));
            },
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          ),
        ],
      ),
    );
  }
}
