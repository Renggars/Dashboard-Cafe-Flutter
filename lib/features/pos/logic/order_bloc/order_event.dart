import 'package:equatable/equatable.dart';
import 'package:cafe/features/pos/data/models/product.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';
import 'package:cafe/features/pos/data/models/order_request.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderSettings extends OrderEvent {}

class AddProductToOrder extends OrderEvent {
  final Product product;
  const AddProductToOrder(this.product);
  @override
  List<Object> get props => [product];
}

class IncrementOrderItem extends OrderEvent {
  final OrderItem orderItem;
  const IncrementOrderItem(this.orderItem);
  @override
  List<Object> get props => [orderItem];
}

class DecrementOrderItem extends OrderEvent {
  final OrderItem orderItem;
  const DecrementOrderItem(this.orderItem);
  @override
  List<Object> get props => [orderItem];
}

class RemoveOrderItem extends OrderEvent {
  final OrderItem orderItem;
  const RemoveOrderItem(this.orderItem);
  @override
  List<Object> get props => [orderItem];
}

class DoOrderEvent extends OrderEvent {
  final OrderRequest request;
  const DoOrderEvent(this.request);
  @override
  List<Object> get props => [request];
}

class ResetOrder extends OrderEvent {}

// Event untuk Riwayat Pesanan
class FetchOrderHistory extends OrderEvent {
  final String status;
  final String search;
  final bool isRefresh;

  const FetchOrderHistory({
    required this.status,
    this.search = '',
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [status, search, isRefresh];
}

class FetchNextOrderPage extends OrderEvent {
  final String status;
  final String search;

  const FetchNextOrderPage({required this.status, this.search = ''});

  @override
  List<Object?> get props => [status, search];
}
