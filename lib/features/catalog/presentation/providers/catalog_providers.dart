import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/product_repository.dart';
import '../../domain/models/product.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
    firestore: FirebaseFirestore.instance,
  );
});

final selectedCategoryProvider = StateProvider<CategoryId>((ref) {
  return CategoryId.all;
});

final productSearchQueryProvider = StateProvider<String>((ref) {
  return '';
});

final allProductsProvider = StreamProvider<List<Product>>((ref) async* {
  final repository = ref.watch(productRepositoryProvider);
  yield* repository.watchProducts();
});

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(allProductsProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(productSearchQueryProvider);
  final repository = ref.watch(productRepositoryProvider);

  return productsAsync.whenData(
    (products) => repository.filterProducts(
      products: products,
      selectedCategory: selectedCategory,
      searchQuery: searchQuery,
    ),
  );
});

final featuredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(allProductsProvider);
  final repository = ref.watch(productRepositoryProvider);
  return productsAsync.whenData(repository.featuredProducts);
});

final categoriesProvider = Provider<List<ProductCategory>>((ref) {
  return ProductCategory.seed;
});

final productByIdProvider = FutureProvider.family<Product?, String>((
  ref,
  productId,
) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(productId);
});
