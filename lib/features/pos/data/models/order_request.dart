// lib/features/pos/data/models/order_request.dart

class OrderRequest {
  final String? customerName;
  final String paymentType; // "CASH", "QRIS", dll
  final List<OrderItemRequest> items;
  final String? notes;
  final String? tableNumber;

  OrderRequest({
    this.customerName,
    required this.paymentType,
    required this.items,
    this.notes,
    this.tableNumber,
  });

  Map<String, dynamic> toJson() => {
        "customerName": customerName ?? "",
        "paymentType": paymentType,
        "items": items.map((e) => e.toJson()).toList(),
        "notes": notes ?? "",
        "tableNumber": tableNumber,
      };
}

class OrderItemRequest {
  final int menuId;
  final int quantity;

  OrderItemRequest({required this.menuId, required this.quantity});

  Map<String, dynamic> toJson() => {
        "menuId": menuId,
        "quantity": quantity,
      };
}
