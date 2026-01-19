import 'package:cafe/features/pos/data/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_bloc.dart';
import 'package:cafe/features/pos/domain/repositories/product_repository.dart';
import 'package:cafe/features/pos/data/repositories/product_repository_impl.dart';

// Import baru untuk Auth

final getIt = GetIt.instance;

void initDependencies() {
  // ===========================================================================
  // 1. SERVICES (External API Calls)
  // ===========================================================================

  // Daftarkan AuthService sebagai LazySingleton agar hanya dibuat satu kali
  getIt.registerLazySingleton<AuthService>(() => AuthService());

  // ===========================================================================
  // 2. REPOSITORIES (Data Layer)
  // ===========================================================================

  // DAFTARKAN: <Interface> , () => Implementasi
  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());

  // ===========================================================================
  // 3. BLOC / LOGIC (Presentation Layer)
  // ===========================================================================

  // ProductBloc membutuhkan ProductRepository
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );

  // OrderBloc (biasanya Factory karena state-nya sering di-reset per sesi)
  getIt.registerFactory<OrderBloc>(() => OrderBloc());
}
