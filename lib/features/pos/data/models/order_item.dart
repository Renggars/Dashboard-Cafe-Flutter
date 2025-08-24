// lib/features/pos/data/models/order_item.dart
import 'package:equatable/equatable.dart';
import 'package:cafe/features/pos/data/models/product.dart';

class OrderItem extends Equatable {
  final Product product;
  final int quantity;

  const OrderItem({
    required this.product,
    required this.quantity,
  });

  int get totalPrice => product.price * quantity;

  OrderItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return OrderItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object> get props => [product, quantity];
}
