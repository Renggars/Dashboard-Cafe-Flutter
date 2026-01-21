import 'package:cafe/features/pos/data/repositories/order_repository.dart';
import 'package:cafe/features/pos/data/repositories/setting_repository.dart';
import 'package:get_it/get_it.dart';
// Core Data Sources
import 'package:cafe/core/data/datasources/auth_local_datasource.dart';

// Services
import 'package:cafe/features/pos/data/services/auth_service.dart';
import 'package:cafe/features/pos/data/services/setting_service.dart';
import 'package:cafe/features/pos/data/services/product_service.dart';
import 'package:cafe/features/pos/data/services/category_service.dart';

// Repositories
import 'package:cafe/features/pos/domain/repositories/product_repository.dart';
import 'package:cafe/features/pos/data/repositories/product_repository_impl.dart';
import 'package:cafe/features/pos/domain/repositories/category_repository.dart';
import 'package:cafe/features/pos/data/repositories/category_repository_impl.dart';

// Logic (Blocs)
import 'package:cafe/features/pos/logic/order_bloc/order_bloc.dart';
import 'package:cafe/features/pos/logic/product_bloc/product_bloc.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // ===========================================================================
  // 0. DATA SOURCES (Local Storage)
  // ===========================================================================

  // Daftarkan AuthLocalDatasource untuk mengelola token di SharedPreferences
  getIt.registerLazySingleton<AuthLocalDatasource>(() => AuthLocalDatasource());

  // ===========================================================================
  // 1. SERVICES (External API Calls)
  // ===========================================================================

  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<SettingService>(() => SettingService());
  getIt.registerLazySingleton<ProductService>(() => ProductService());
  getIt.registerLazySingleton<CategoryService>(() => CategoryService());

  // ===========================================================================
  // 2. REPOSITORIES (Data Layer)
  // ===========================================================================

  getIt.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl());

  getIt.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl());

  // Daftarkan Repository baru
  getIt.registerLazySingleton<SettingRepository>(
    () => SettingRepositoryImpl(getIt<SettingService>()),
  );
  getIt.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(),
  );

  // ===========================================================================
  // 3. BLOC / LOGIC (Update bagian ini)
  // ===========================================================================
  getIt.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: getIt<ProductRepository>()),
  );

  // Berikan dependency repository ke OrderBloc
  getIt.registerFactory<OrderBloc>(
    () => OrderBloc(
      getIt<OrderRepository>(),
      getIt<SettingRepository>(),
    ),
  );
}
