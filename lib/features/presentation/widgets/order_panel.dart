import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';

class OrderPanel extends StatelessWidget {
  const OrderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
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
              Text(
                'Item',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
              ),
              Text(
                'Qty',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
              ),
              Text(
                'Price',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state.orderItems.isEmpty) {
                  return const Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(color: AppColors.fontGrey),
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.orderItems.length,
                  itemBuilder: (context, index) {
                    return OrderListItem(item: state.orderItems[index]);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1, height: 10),
          _buildPaymentMethods(),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Payment',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return GridView.count(
      shrinkWrap: true, // biar tinggi grid ngikut konten
      physics: const NeverScrollableScrollPhysics(), // disable scroll grid
      crossAxisCount: 3, // 3 kolom
      crossAxisSpacing: 24, // jarak antar kolom
      childAspectRatio: 1.6, // rasio lebar : tinggi, bisa disesuaikan
      children: [
        _paymentMethodButton(Icons.money, 'CASH'),
        _paymentMethodButton(Icons.qr_code, 'QR'),
        _paymentMethodButton(Icons.credit_card, 'TRANSFER'),
      ],
    );
  }

  Widget _paymentMethodButton(IconData icon, String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 32),
          const SizedBox(height: 6), // jarak icon dan label
          Text(
            label,
            style: const TextStyle(color: AppColors.primary, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

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
      child: Column(
        children: [
          Row(
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

              // Tengah
              _buildQuantitySelector(context),
              const SizedBox(width: 30),

              // Kanan
              SizedBox(
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
          const SizedBox(height: 12),
          TextField(
            style: const TextStyle(fontSize: 20, color: AppColors.fontGrey),
            decoration: InputDecoration(
              hintText: 'Notes',
              hintStyle: const TextStyle(color: AppColors.fontGrey),
              enabledBorder: OutlineInputBorder(
                // border normal
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                // border saat fokus
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(20),
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
          Text(item.quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
