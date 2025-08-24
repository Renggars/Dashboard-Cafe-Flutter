// lib/features/pos/presentation/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/data/models/product.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_event.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_state.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);

    return InkWell(
      onTap: () {
        context.read<OrderBloc>().add(AddProductToOrder(product));
      },
      borderRadius: BorderRadius.circular(14),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Image.network(
                        // product.imageUrl,
                        "https://picsum.photos/200",
                        fit: BoxFit.contain,
                        height: 80,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image,
                                size: 80, color: AppColors.fontGrey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.font,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.categoryName ?? '',
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.fontGrey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    formatCurrency.format(product.price),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.font,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                final orderItem = state.orderItems
                    .where((item) => item.product.id == product.id)
                    .firstOrNull;
                if (orderItem != null) {
                  return Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        orderItem.quantity.toString(),
                        style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
