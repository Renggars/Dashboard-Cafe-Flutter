import 'package:cafe/features/pos/data/models/product.dart';
import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final Product product;
  final int quantity;
  final String notes;

  const OrderItem({
    required this.product,
    this.quantity = 1,
    this.notes = '',
  });

  OrderItem copyWith({
    Product? product,
    int? quantity,
    String? notes,
  }) {
    return OrderItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => product.price * quantity;

  @override
  List<Object> get props => [product, quantity, notes];
}
