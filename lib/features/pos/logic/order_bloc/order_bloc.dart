import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';
import 'package:cafe/features/pos/data/models/product.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const OrderState()) {
    on<AddProductToOrder>(_onAddProduct);
    on<IncrementOrderItem>(_onIncrementItem);
    on<DecrementOrderItem>(_onDecrementItem);
  }

  void _onAddProduct(AddProductToOrder event, Emitter<OrderState> emit) {
    final List<OrderItem> updatedItems = List.from(state.orderItems);
    final int index =
        updatedItems.indexWhere((item) => item.product.id == event.product.id);

    if (index != -1) {
      // Jika produk sudah ada, tambah quantity
      final currentItem = updatedItems[index];
      updatedItems[index] =
          currentItem.copyWith(quantity: currentItem.quantity + 1);
    } else {
      // Jika produk belum ada, tambahkan ke list
      updatedItems.add(OrderItem(product: event.product, quantity: 1));
    }
    emit(state.copyWith(orderItems: updatedItems));
  }

  void _onIncrementItem(IncrementOrderItem event, Emitter<OrderState> emit) {
    final List<OrderItem> updatedItems = List.from(state.orderItems);
    final int index = updatedItems.indexOf(event.orderItem);

    if (index != -1) {
      final currentItem = updatedItems[index];
      updatedItems[index] =
          currentItem.copyWith(quantity: currentItem.quantity + 1);
      emit(state.copyWith(orderItems: updatedItems));
    }
  }

  void _onDecrementItem(DecrementOrderItem event, Emitter<OrderState> emit) {
    final List<OrderItem> updatedItems = List.from(state.orderItems);
    final int index = updatedItems.indexOf(event.orderItem);

    if (index != -1) {
      final currentItem = updatedItems[index];
      if (currentItem.quantity > 1) {
        updatedItems[index] =
            currentItem.copyWith(quantity: currentItem.quantity - 1);
      } else {
        // Jika quantity 1, hapus dari list
        updatedItems.removeAt(index);
      }
      emit(state.copyWith(orderItems: updatedItems));
    }
  }
}
