// lib/features/pos/logic/product_bloc/product_state.dart
import 'package:equatable/equatable.dart';
import 'package:cafe/features/pos/data/models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ProductError extends ProductState {
  final String message;
  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
