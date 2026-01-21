import 'package:cafe/features/pos/data/models/setting_model.dart';
import 'package:cafe/features/pos/data/services/setting_service.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_state.dart';
import 'package:cafe/features/presentation/widgets/homeWidgets/payment_modal.dart';
import 'package:cafe/injection.dart';
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
      child: FutureBuilder<SettingModel>(
        future: getIt<SettingService>().getGlobalSettings(),
        builder: (context, settingSnapshot) {
          return BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              // 1. Kalkulasi
              double subTotal = state.orderItems
                  .fold(0, (sum, item) => sum + item.totalPrice);
              final settings = settingSnapshot.data;

              double taxP = (settings?.isTaxActive ?? false)
                  ? settings!.taxPercentage
                  : 0;
              double serviceP = (settings?.isServiceActive ?? false)
                  ? settings!.servicePercentage
                  : 0;
              double discountP = (settings?.isDiscountActive ?? false)
                  ? settings!.discountPercentage
                  : 0;

              double discountAmount = subTotal * (discountP / 100);
              double amountAfterDiscount = subTotal - discountAmount;
              double serviceFee = amountAfterDiscount * (serviceP / 100);
              double tax = amountAfterDiscount * (taxP / 100);
              double grandTotal = amountAfterDiscount + serviceFee + tax;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Orders #',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                  const SizedBox(height: 10),
                  _buildHeaderTable(),
                  const Divider(thickness: 1),

                  // List Order Items dengan Swipe to Delete
                  Expanded(
                    child: state.orderItems.isEmpty
                        ? const Center(
                            child: Text('No orders yet',
                                style: TextStyle(color: AppColors.fontGrey)))
                        : ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: state.orderItems.length,
                            itemBuilder: (context, index) {
                              final item = state.orderItems[index];
                              return Dismissible(
                                key: ValueKey(item.product.id), // KEY UNIK
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  context
                                      .read<OrderBloc>()
                                      .add(RemoveOrderItem(item));
                                },
                                child: OrderListItem(item: item),
                              );
                            },
                          ),
                  ),

                  const SizedBox(height: 20),
                  _buildTransactionSummary(
                    subTotal: subTotal,
                    serviceFee: serviceFee,
                    tax: tax,
                    discount: discountAmount,
                    grandTotal: grandTotal,
                    taxP: taxP,
                    serviceP: serviceP,
                    discountP: discountP,
                  ),
                  const SizedBox(height: 20),
                  _buildPayButton(context, state, grandTotal),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeaderTable() {
    return const Row(
      children: [
        Expanded(
            flex: 4,
            child: Text('Item',
                style: TextStyle(color: AppColors.primary, fontSize: 18))),
        Expanded(
            flex: 2,
            child: Text('Qty',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.primary, fontSize: 18))),
        Expanded(
            flex: 3,
            child: Text('Price',
                textAlign: TextAlign.right,
                style: TextStyle(color: AppColors.primary, fontSize: 18))),
      ],
    );
  }

  Widget _buildPayButton(
      BuildContext context, OrderState state, double grandTotal) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.orderItems.isEmpty
            ? null
            : () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => PaymentModal(
                    grandTotal: grandTotal,
                    cartItems: state.orderItems,
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: const Text('Lanjutkan Pembayaran',
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTransactionSummary({
    required double subTotal,
    required double serviceFee,
    required double tax,
    required double discount,
    required double grandTotal,
    required double taxP,
    required double serviceP,
    required double discountP,
  }) {
    final formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return Column(
      children: [
        _buildSummaryRow('Subtotal', '', formatCurrency.format(subTotal)),
        if (discount > 0)
          _buildSummaryRow('Diskon', '${discountP.toInt()}%',
              '- ${formatCurrency.format(discount)}'),
        if (tax > 0)
          _buildSummaryRow(
              'Pajak PB1', '${taxP.toInt()}%', formatCurrency.format(tax)),
        if (serviceFee > 0)
          _buildSummaryRow('Layanan', '${serviceP.toInt()}%',
              formatCurrency.format(serviceFee)),
        const Divider(thickness: 1, height: 20),
        _buildSummaryRow('Total Akhir', '', formatCurrency.format(grandTotal),
            isBold: true),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String percentage, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? AppColors.primary : AppColors.fontGrey)),
          if (percentage.isNotEmpty)
            Text(percentage,
                style:
                    const TextStyle(fontSize: 14, color: AppColors.fontGrey)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isBold ? AppColors.primary : AppColors.fontGrey)),
        ],
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final OrderItem item;
  // Menerima Key dan diteruskan ke super
  const OrderListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(formatCurrency.format(item.product.price),
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.fontGrey)),
              ],
            ),
          ),
          Expanded(flex: 2, child: _buildQuantitySelector(context, item)),
          Expanded(
            flex: 3,
            child: Text(
              formatCurrency.format(item.totalPrice),
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(BuildContext context, OrderItem item) {
    return Container(
      // Membatasi lebar maksimal agar tidak menabrak harga
      constraints: const BoxConstraints(maxWidth: 100),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min, // SANGAT PENTING: Agar Row tidak serakah ruang
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            // Mengecilkan ukuran tap area agar tidak overflow
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4), // Padding lebih kecil
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove, size: 14, color: AppColors.primary),
            onPressed: () =>
                context.read<OrderBloc>().add(DecrementOrderItem(item)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              item.quantity.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // Pastikan ukuran font tidak terlalu besar
              ),
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.add, size: 14, color: AppColors.primary),
            onPressed: () =>
                context.read<OrderBloc>().add(IncrementOrderItem(item)),
          ),
        ],
      ),
    );
  }
}
