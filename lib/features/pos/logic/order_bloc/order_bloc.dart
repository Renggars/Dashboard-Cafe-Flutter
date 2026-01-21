import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_event.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_state.dart';
import 'package:cafe/features/pos/data/repositories/order_repository.dart';
import 'package:cafe/features/pos/data/repositories/setting_repository.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepo;
  final SettingRepository _settingRepo;

  OrderBloc(this._orderRepo, this._settingRepo) : super(const OrderState()) {
    // POS Checkout Handlers
    on<FetchOrderSettings>(_onFetchSettings);
    on<AddProductToOrder>(_onAddProductToOrder);
    on<IncrementOrderItem>(_onIncrementOrderItem);
    on<DecrementOrderItem>(_onDecrementOrderItem);
    on<RemoveOrderItem>(_onRemoveOrderItem);
    on<DoOrderEvent>(_onDoOrder);
    on<ResetOrder>(_onResetOrder);

    // History & Pagination Handlers (Wajib Didaftarkan di sini)
    on<FetchOrderHistory>(_onFetchOrderHistory);
    on<FetchNextOrderPage>(_onFetchNextOrderPage);
  }

  // --- LOGIKA HISTORY & SEARCH ---
  Future<void> _onFetchOrderHistory(
      FetchOrderHistory event, Emitter<OrderState> emit) async {
    emit(state.copyWith(isHistoryLoading: true, orders: [], currentPage: 1));
    try {
      final response = await _orderRepo.getOrders(
        status: event.status,
        search: event.search,
        page: 1,
        limit: 25,
      );

      emit(state.copyWith(
        isHistoryLoading: false,
        orders: response['orders'],
        totalItems: response['pagination']['totalItems'] ?? 0,
        totalPages: response['pagination']['totalPages'] ?? 1,
        currentPage: 1,
      ));
    } catch (e) {
      emit(state.copyWith(isHistoryLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchNextOrderPage(
      FetchNextOrderPage event, Emitter<OrderState> emit) async {
    // Validasi agar tidak fetch berlebihan
    if (state.currentPage >= state.totalPages || state.isMoreLoading) return;

    emit(state.copyWith(isMoreLoading: true));
    try {
      final nextPage = state.currentPage + 1;
      final response = await _orderRepo.getOrders(
        status: event.status,
        search: event.search,
        page: nextPage,
        limit: 25,
      );

      emit(state.copyWith(
        isMoreLoading: false,
        orders: [...state.orders, ...response['orders']],
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(state.copyWith(isMoreLoading: false));
    }
  }

  // --- LOGIKA POS (TETAP SAMA) ---
  Future<void> _onFetchSettings(
      FetchOrderSettings event, Emitter<OrderState> emit) async {
    try {
      final settings = await _settingRepo.getGlobalSettings();
      emit(state.copyWith(
        taxPercentage: settings.taxPercentage.toDouble(),
        isTaxActive: settings.isTaxActive,
        servicePercentage: settings.servicePercentage.toDouble(),
        isServiceActive: settings.isServiceActive,
        discountPercentage: settings.discountPercentage.toDouble(),
        isDiscountActive: settings.isDiscountActive,
      ));
    } catch (e) {
      print("Error fetching settings: $e");
    }
  }

  void _onAddProductToOrder(AddProductToOrder event, Emitter<OrderState> emit) {
    final existingIndex =
        state.orderItems.indexWhere((i) => i.product.id == event.product.id);
    final List<OrderItem> updatedItems = List.from(state.orderItems);
    if (existingIndex != -1) {
      updatedItems[existingIndex] = updatedItems[existingIndex]
          .copyWith(quantity: updatedItems[existingIndex].quantity + 1);
    } else {
      updatedItems.add(OrderItem(product: event.product, quantity: 1));
    }
    emit(state.copyWith(
        orderItems: updatedItems, status: OrderApiStatus.initial));
  }

  void _onIncrementOrderItem(
      IncrementOrderItem event, Emitter<OrderState> emit) {
    final updatedItems = state.orderItems
        .map((item) => item.product.id == event.orderItem.product.id
            ? item.copyWith(quantity: item.quantity + 1)
            : item)
        .toList();
    emit(state.copyWith(orderItems: updatedItems));
  }

  void _onDecrementOrderItem(
      DecrementOrderItem event, Emitter<OrderState> emit) {
    final List<OrderItem> updatedItems = [];
    for (var item in state.orderItems) {
      if (item.product.id == event.orderItem.product.id) {
        if (item.quantity > 1)
          updatedItems.add(item.copyWith(quantity: item.quantity - 1));
      } else {
        updatedItems.add(item);
      }
    }
    emit(state.copyWith(orderItems: updatedItems));
  }

  void _onRemoveOrderItem(RemoveOrderItem event, Emitter<OrderState> emit) {
    final updatedItems = state.orderItems
        .where((item) => item.product.id != event.orderItem.product.id)
        .toList();
    emit(state.copyWith(orderItems: updatedItems));
  }

  Future<void> _onDoOrder(DoOrderEvent event, Emitter<OrderState> emit) async {
    emit(state.copyWith(status: OrderApiStatus.loading));
    try {
      final response = await _orderRepo.createOrder(event.request);
      emit(state.copyWith(
          status: OrderApiStatus.success, orderResponse: response));
    } catch (e) {
      emit(state.copyWith(
          status: OrderApiStatus.error, errorMessage: e.toString()));
    }
  }

  void _onResetOrder(ResetOrder event, Emitter<OrderState> emit) {
    emit(state.copyWith(
        orderItems: [],
        status: OrderApiStatus.initial,
        errorMessage: null,
        orderResponse: null));
  }
}
