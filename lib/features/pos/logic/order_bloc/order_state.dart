import 'package:equatable/equatable.dart';
import 'package:cafe/features/pos/data/models/order_item.dart';

enum OrderApiStatus { initial, loading, success, error }

class OrderState extends Equatable {
  final List<OrderItem> orderItems;
  final OrderApiStatus status;
  final String? errorMessage;
  final dynamic orderResponse;

  final double taxPercentage;
  final bool isTaxActive;
  final double servicePercentage;
  final bool isServiceActive;
  final double discountPercentage;
  final bool isDiscountActive;

  final List<dynamic> orders;
  final bool isHistoryLoading;
  final bool isMoreLoading;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const OrderState({
    this.orderItems = const [],
    this.status = OrderApiStatus.initial,
    this.errorMessage,
    this.orderResponse,
    this.taxPercentage = 0.0,
    this.isTaxActive = false,
    this.servicePercentage = 0.0,
    this.isServiceActive = false,
    this.discountPercentage = 0.0,
    this.isDiscountActive = false,
    this.orders = const [],
    this.isHistoryLoading = false,
    this.isMoreLoading = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
  });

  double get subTotal => orderItems.fold(
      0, (sum, item) => sum + (item.product.price * item.quantity));
  double get taxAmount => isTaxActive ? (subTotal * (taxPercentage / 100)) : 0;
  double get serviceAmount =>
      isServiceActive ? (subTotal * (servicePercentage / 100)) : 0;
  double get discountAmount =>
      isDiscountActive ? (subTotal * (discountPercentage / 100)) : 0;
  double get totalBill => subTotal + taxAmount + serviceAmount - discountAmount;

  OrderState copyWith({
    List<OrderItem>? orderItems,
    OrderApiStatus? status,
    String? errorMessage,
    dynamic orderResponse,
    double? taxPercentage,
    bool? isTaxActive,
    double? servicePercentage,
    bool? isServiceActive,
    double? discountPercentage,
    bool? isDiscountActive,
    List<dynamic>? orders,
    bool? isHistoryLoading,
    bool? isMoreLoading,
    int? currentPage,
    int? totalPages,
    int? totalItems,
  }) {
    return OrderState(
      orderItems: orderItems ?? this.orderItems,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      orderResponse: orderResponse ?? this.orderResponse,
      taxPercentage: taxPercentage ?? this.taxPercentage,
      isTaxActive: isTaxActive ?? this.isTaxActive,
      servicePercentage: servicePercentage ?? this.servicePercentage,
      isServiceActive: isServiceActive ?? this.isServiceActive,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isDiscountActive: isDiscountActive ?? this.isDiscountActive,
      orders: orders ?? this.orders,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      isMoreLoading: isMoreLoading ?? this.isMoreLoading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object?> get props => [
        orderItems,
        status,
        errorMessage,
        orderResponse,
        taxPercentage,
        isTaxActive,
        servicePercentage,
        isServiceActive,
        discountPercentage,
        isDiscountActive,
        orders,
        isHistoryLoading,
        isMoreLoading,
        currentPage,
        totalPages,
        totalItems,
      ];
}
