import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe/core/constants/colors.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_event.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_state.dart';
import 'package:intl/intl.dart';

class PaidOrderPage extends StatefulWidget {
  const PaidOrderPage({super.key});

  @override
  State<PaidOrderPage> createState() => _PaidOrderPageState();
}

class _PaidOrderPageState extends State<PaidOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchInitial();

    // Berpindah tab akan mengambil data ulang
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchInitial();
      }
    });

    // Infinite scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _fetchNextPage();
      }
    });
  }

  // Mengirim event FetchOrderHistory (Reset Page ke 1)
  void _fetchInitial() {
    context.read<OrderBloc>().add(FetchOrderHistory(
          status: _tabController.index == 0 ? 'PENDING' : 'CONFIRMED',
          search: _searchController.text,
        ));
  }

  // Mengirim event FetchNextOrderPage (Load data tambahan)
  void _fetchNextPage() {
    context.read<OrderBloc>().add(FetchNextOrderPage(
          status: _tabController.index == 0 ? 'PENDING' : 'CONFIRMED',
          search: _searchController.text,
        ));
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _fetchInitial());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Daftar Pesanan',
            style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 28)), // Ukuran judul diperbesar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Cari ID Order atau Nama Pelanggan...',
                      prefixIcon:
                          Icon(Icons.search, color: Colors.blueGrey, size: 28),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  return TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 4,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    tabs: [
                      Tab(
                          text:
                              "Pending ${_tabController.index == 0 ? '(${state.totalItems})' : ''}"),
                      Tab(
                          text:
                              "Confirmed ${_tabController.index == 1 ? '(${state.totalItems})' : ''}"),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.isHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text("Tidak ada pesanan ditemukan",
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(20),
            itemCount: state.orders.length + (state.isMoreLoading ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              if (index == state.orders.length) {
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator()));
              }
              return _OrderTile(order: state.orders[index]);
            },
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final dynamic order;
  const _OrderTile({required this.order});

  // Helper memformat jam: 2026-01-20T05:13:00 -> 05:13
  String _formatTime(String? dateStr) {
    if (dateStr == null) return "--:--";
    try {
      final DateTime date = DateTime.parse(dateStr).toLocal();
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return "--:--";
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = order['status'] ?? 'PENDING';
    final bool isPending = status == 'PENDING';
    final List items = order['items'] ?? [];

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.grey.shade100)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        // Ikon lead diperbesar & warna sesuai status (Bukan centang jika pending)
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isPending
                ? Colors.orange.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isPending ? Icons.timer_outlined : Icons.check_circle_outline,
            color: isPending ? Colors.orange : Colors.green,
            size: 32,
          ),
        ),
        title: Row(
          children: [
            Text("#${order['id']}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTime(order['createdAt']),
                style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "${order['customerName'] ?? 'Guest'} • Meja ${order['tableNumber'] ?? '-'}",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ),
        trailing: Text(
          NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0)
              .format(order['totalPrice'] ?? 0),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.primary),
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Items:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(height: 20),
                // Map items dengan data 'menu' dari backend
                ...items.map((item) {
                  final menuName = item['menu'] != null
                      ? item['menu']['name']
                      : "Unknown Item";
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item['quantity']}x $menuName",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          NumberFormat.currency(
                                  locale: 'id', symbol: 'Rp ', decimalDigits: 0)
                              .format(item['price'] * item['quantity']),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                // Tombol aksi dinamis
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Logic Print atau Bayar di sini
                    },
                    icon: Icon(
                        isPending ? Icons.payments_outlined : Icons.print,
                        color: Colors.white),
                    label: Text(
                      isPending ? "PROSES PEMBAYARAN" : "CETAK STRUK",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.1),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isPending ? Colors.orange : AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
