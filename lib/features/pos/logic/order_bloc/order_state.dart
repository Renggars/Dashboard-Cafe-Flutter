part of 'order_bloc.dart';

class OrderState extends Equatable {
  final List<OrderItem> orderItems;

  const OrderState({this.orderItems = const []});

  double get subtotal {
    return orderItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItems {
    return orderItems.fold(0, (sum, item) => sum + item.quantity);
  }

  OrderState copyWith({
    List<OrderItem>? orderItems,
  }) {
    return OrderState(
      orderItems: orderItems ?? this.orderItems,
    );
  }

  @override
  List<Object> get props => [orderItems];
}
