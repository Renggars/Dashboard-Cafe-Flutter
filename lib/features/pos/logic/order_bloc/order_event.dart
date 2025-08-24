// lib/features/pos/logic/order_bloc/order_event.dart
import 'package:equatable/equatable.dart';
import 'package:cafe/features/pos/data/models/product.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

// Event untuk menambah produk ke pesanan
class AddProductToOrder extends OrderEvent {
  final Product product;
  const AddProductToOrder(this.product);

  @override
  List<Object> get props => [product];
}

// Event untuk menambah kuantitas item yang sudah ada
class IncrementOrderItem extends OrderEvent {
  final OrderItem orderItem;
  const IncrementOrderItem(this.orderItem);

  @override
  List<Object> get props => [orderItem];
}

// Event untuk mengurangi kuantitas item
class DecrementOrderItem extends OrderEvent {
  final OrderItem orderItem;
  const DecrementOrderItem(this.orderItem);

  @override
  List<Object> get props => [orderItem];
}

// Event untuk menghapus item dari pesanan
class RemoveOrderItem extends OrderEvent {
  final OrderItem orderItem;
  const RemoveOrderItem(this.orderItem);

  @override
  List<Object> get props => [orderItem];
}
