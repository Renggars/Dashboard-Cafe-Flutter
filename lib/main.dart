// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'features/pos/logic/order_bloc/order_bloc.dart';
import 'features/pos/logic/product_bloc/product_bloc.dart';
import 'injection.dart'; // DIUBAH: Import file injection

void main() async {
  // BARU: Pastikan semua binding Flutter siap sebelum menjalankan kode async.
  WidgetsFlutterBinding.ensureInitialized();

  // BARU: Panggil setup dependency injection di sini.
  initDependencies();

  // Inisialisasi format tanggal (sudah benar).
  await initializeDateFormatting('id_ID', null);

  // DIHAPUS: Inisialisasi manual ProductRepository dihapus.
  // final ProductRepository productRepository = ProductRepository(); <-- HAPUS BARIS INI

  runApp(
    // MultiBlocProvider tetap digunakan untuk menyediakan BLoC ke widget tree.
    MultiBlocProvider(
      providers: [
        // DIUBAH: BLoC dibuat dengan mengambil instance dari GetIt.
        // Tidak ada lagi event `add(LoadProducts())` di sini.
        BlocProvider(
          create: (context) => getIt<ProductBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<OrderBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
