import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/data/models/order_item.dart' as ui_model;
import 'package:cafe/features/pos/data/models/order_request.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_event.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_state.dart';

enum PaymentType { CASH, QRIS, DEBIT, CREDIT, TRANSFER }

class PaymentModal extends StatefulWidget {
  final double grandTotal;
  final List<ui_model.OrderItem> cartItems;

  const PaymentModal({
    super.key,
    required this.grandTotal,
    required this.cartItems,
  });

  @override
  State<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends State<PaymentModal> {
  PaymentType selectedType = PaymentType.CASH;
  final TextEditingController _cashController = TextEditingController();
  final formatCurrency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  // Tambahkan variabel lokal untuk menyimpan total yang sudah dibulatkan
  late int roundedGrandTotal;

  @override
  void initState() {
    super.initState();
    // Bulatkan total ke integer terdekat agar tidak ada selisih desimal (Rp 1)
    roundedGrandTotal = widget.grandTotal.round();
    _cashController.text = roundedGrandTotal.toString();
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  void _handleCompleteTransaction() {
    if (selectedType == PaymentType.CASH) {
      // Pastikan perbandingan menggunakan angka bulat
      int inputUang = int.tryParse(_cashController.text) ?? 0;
      if (inputUang < roundedGrandTotal) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Uang tunai kurang!"),
              backgroundColor: Colors.orange),
        );
        return;
      }
    }

    final List<OrderItemRequest> apiItems = widget.cartItems.map((item) {
      return OrderItemRequest(
        menuId: item.product.id,
        quantity: item.quantity,
      );
    }).toList();

    final request = OrderRequest(
      customerName: "Pelanggan POS",
      paymentType: selectedType.name,
      items: apiItems,
      tableNumber: null,
    );

    context.read<OrderBloc>().add(DoOrderEvent(request));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state.status == OrderApiStatus.success) {
          _showSuccessReceipt(context);
          context.read<OrderBloc>().add(ResetOrder());
          Navigator.pop(context);
        }

        if (state.status == OrderApiStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Terjadi kesalahan"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          child: Container(
            width: screenSize.width * 0.85,
            height: screenSize.height * 0.8,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: Row(
                      children: [
                        _buildSidebar(screenSize),
                        Expanded(child: _buildMainContent()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Checkout",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500)),
              Text("Metode Pembayaran",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.blueGrey.shade900)),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded, size: 28),
            style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(Size screenSize) {
    return Container(
      width: screenSize.width * 0.28,
      decoration: BoxDecoration(
        color: Colors.grey.shade50.withOpacity(0.5),
        border: Border(right: BorderSide(color: Colors.grey.shade200)),
      ),
      child: _buildPaymentTypeGrid(),
    );
  }

  Widget _buildPaymentTypeGrid() {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: PaymentType.values.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final type = PaymentType.values[index];
        bool isSelected = selectedType == type;
        return InkWell(
          onTap: () => setState(() => selectedType = type),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(_getIconForType(type),
                    color: isSelected ? Colors.white : Colors.grey.shade600),
                const SizedBox(width: 16),
                Text(type.name,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : Colors.blueGrey.shade700)),
                const Spacer(),
                if (isSelected)
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          _buildTotalCard(),
          const SizedBox(height: 40),
          Expanded(
            child: selectedType == PaymentType.CASH
                ? _buildCashInputSection()
                : _buildNonCashPlaceholder(),
          ),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("TOTAL TAGIHAN",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(formatCurrency.format(roundedGrandTotal),
              style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        bool isLoading = state.status == OrderApiStatus.loading;

        return SizedBox(
          width: double.infinity,
          height: 75,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleCompleteTransaction,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey.shade900,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text("SELESAIKAN TRANSAKSI",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
          ),
        );
      },
    );
  }

  Widget _buildChangeIndicator(int kembalian) {
    bool isEnough = kembalian >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isEnough ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(isEnough ? "Kembalian" : "Kurang",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isEnough ? Colors.green : Colors.orange)),
          Text(formatCurrency.format(kembalian.abs()),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isEnough ? Colors.green : Colors.orange)),
        ],
      ),
    );
  }

  Widget _buildCashInputSection() {
    int inputUang = int.tryParse(_cashController.text) ?? 0;
    int kembalian = inputUang - roundedGrandTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Uang Tunai Diterima:",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 12),
        TextField(
          controller: _cashController,
          keyboardType: TextInputType.number,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: const Icon(Icons.money, color: Colors.green),
            suffixIcon: IconButton(
              icon:
                  const Icon(Icons.backspace_outlined, color: Colors.redAccent),
              onPressed: () {
                _cashController.clear();
                setState(() {});
              },
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildQuickCashButton("Uang Pas", roundedGrandTotal.toDouble()),
            _buildQuickCashButton("Rp 20.000", 20000),
            _buildQuickCashButton("Rp 50.000", 50000),
            _buildQuickCashButton("Rp 100.000", 100000),
          ],
        ),
        const SizedBox(height: 24),
        _buildChangeIndicator(kembalian),
      ],
    );
  }

  Widget _buildQuickCashButton(String label, double amount) {
    return InkWell(
      onTap: () {
        setState(() {
          // Input ke controller dalam bentuk String integer
          _cashController.text = amount.round().toString();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueGrey.shade100),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: Colors.blueGrey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildNonCashPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text("Silakan gunakan terminal pembayaran luar.",
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  void _showSuccessReceipt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Transaksi Berhasil Disimpan"),
          backgroundColor: Colors.green),
    );
  }

  IconData _getIconForType(PaymentType type) {
    switch (type) {
      case PaymentType.CASH:
        return Icons.payments_rounded;
      case PaymentType.QRIS:
        return Icons.qr_code_scanner_rounded;
      case PaymentType.DEBIT:
        return Icons.credit_card_rounded;
      case PaymentType.CREDIT:
        return Icons.credit_score_rounded;
      case PaymentType.TRANSFER:
        return Icons.account_balance_rounded;
    }
  }
}
