// lib/injection.dart
import 'package:cafe/features/pos/data/repositories/product_repository_impl.dart';
import 'package:cafe/features/pos/domain/repositories/product_repository.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

// NAMA FUNGSI DIUBAH: Menjadi lebih umum.
void initDependencies() {
  // --- Repositories (Data Layer) ---
  // PENJELASAN: registerLazySingleton memastikan hanya ada satu instance ProductRepositoryImpl
  // selama aplikasi berjalan, dan dibuat hanya saat pertama kali dibutuhkan.
  // Ini efisien untuk objek yang 'mahal' untuk dibuat.
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());

  // --- Blocs (Presentation/Logic Layer) ---
  // PENJELASAN: registerFactory akan membuat instance BLoC yang baru setiap kali diminta.
  // Ini adalah praktik yang aman untuk BLoC agar state-nya selalu bersih
  // saat sebuah halaman/fitur diakses kembali.
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );

  getIt.registerFactory<OrderBloc>(() => OrderBloc());
}
