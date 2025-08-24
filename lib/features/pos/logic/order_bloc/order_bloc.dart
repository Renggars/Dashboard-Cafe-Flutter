// lib/features/pos/logic/order_bloc/order_bloc.dart
import 'package:cafe/features/pos/data/models/order_item.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_event.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<AddProductToOrder>(_onAddProductToOrder);
    on<IncrementOrderItem>(_onIncrementOrderItem);
    on<DecrementOrderItem>(_onDecrementOrderItem);
    on<RemoveOrderItem>(_onRemoveOrderItem);
  }

  void _onAddProductToOrder(AddProductToOrder event, Emitter<OrderState> emit) {
    final existingItemIndex = state.orderItems.indexWhere(
      (item) => item.product.id == event.product.id,
    );

    if (existingItemIndex != -1) {
      // Jika produk sudah ada, tingkatkan kuantitas
      final updatedItems = List<OrderItem>.from(state.orderItems);
      final existingItem = updatedItems[existingItemIndex];
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
      emit(state.copyWith(orderItems: updatedItems));
    } else {
      // Jika produk belum ada, tambahkan item baru
      final newOrderItem = OrderItem(product: event.product, quantity: 1);
      final updatedItems = List<OrderItem>.from(state.orderItems)
        ..add(newOrderItem);
      emit(state.copyWith(orderItems: updatedItems));
    }
  }

  void _onIncrementOrderItem(
      IncrementOrderItem event, Emitter<OrderState> emit) {
    final updatedItems = state.orderItems.map((item) {
      if (item.product.id == event.orderItem.product.id) {
        return item.copyWith(quantity: item.quantity + 1);
      }
      return item;
    }).toList();
    emit(state.copyWith(orderItems: updatedItems));
  }

  void _onDecrementOrderItem(
      DecrementOrderItem event, Emitter<OrderState> emit) {
    final updatedItems = state.orderItems.map((item) {
      if (item.product.id == event.orderItem.product.id) {
        if (item.quantity > 1) {
          return item.copyWith(quantity: item.quantity - 1);
        }
      }
      return item;
    }).toList();
    // Hapus item jika kuantitasnya menjadi 0
    final filteredItems =
        updatedItems.where((item) => item.quantity > 0).toList();
    emit(state.copyWith(orderItems: filteredItems));
  }

  void _onRemoveOrderItem(RemoveOrderItem event, Emitter<OrderState> emit) {
    final updatedItems = state.orderItems
        .where((item) => item.product.id != event.orderItem.product.id)
        .toList();
    emit(state.copyWith(orderItems: updatedItems));
  }
}
