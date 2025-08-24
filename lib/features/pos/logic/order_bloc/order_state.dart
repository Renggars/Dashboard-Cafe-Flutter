// lib/features/pos/logic/order_bloc/order_state.dart
import 'package:equatable/equatable.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';

class OrderState extends Equatable {
  final List<OrderItem> orderItems;

  const OrderState({this.orderItems = const []});

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
