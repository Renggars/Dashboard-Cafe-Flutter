import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cafe/features/pos/data/repositories/product_repository.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';

void main() async {
  // Inisialisasi Repository
  final ProductRepository productRepository = ProductRepository();
  await initializeDateFormatting('id_ID', null);

  runApp(
    // Sediakan BLoC ke seluruh aplikasi menggunakan MultiBlocProvider
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ProductBloc(productRepository)..add(LoadProducts()),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
