part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

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
