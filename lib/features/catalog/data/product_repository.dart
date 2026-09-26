import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../domain/models/product.dart';

class ProductRepository {
  ProductRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static bool get isFirebaseReady {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  CollectionReference<Map<String, dynamic>> get _productsCollection =>
      _firestore.collection('products');

  Stream<List<Product>> watchProducts() {
    if (!isFirebaseReady) {
      return Stream<List<Product>>.value(_sorted(Product.demoProducts()));
    }

    return _productsCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _sorted(Product.demoProducts());
      }
      return _sorted(snapshot.docs
          .map((doc) => Product.fromFirestore(doc.data(), doc.id))
          .toList());
    });
  }

  Future<Product?> getProductById(String productId) async {
    final products = await watchProducts().first;
    for (final product in products) {
      if (product.id == productId) return product;
    }
    return null;
  }

  Future<void> seedDemoProductsIfEmpty() async {
    if (!isFirebaseReady) return;

    final snapshot = await _productsCollection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final batch = _firestore.batch();
    for (final product in Product.demoProducts()) {
      final docRef = _productsCollection.doc(product.id);
      batch.set(docRef, product.toFirestore());
    }
    await batch.commit();
  }

  List<Product> filterProducts({
    required List<Product> products,
    required CategoryId selectedCategory,
    required String searchQuery,
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    return products.where((product) {
      final categoryMatches = selectedCategory == CategoryId.all ||
          product.categoryId == selectedCategory;
      final searchMatches = normalizedQuery.isEmpty ||
          product.name.toLowerCase().contains(normalizedQuery) ||
          product.description.toLowerCase().contains(normalizedQuery);

      return categoryMatches && searchMatches;
    }).toList();
  }

  List<Product> featuredProducts(List<Product> products) {
    final featured = products.where((product) => product.isFeatured).toList();
    if (featured.isNotEmpty) return _sorted(featured);
    return _sorted(products).take(4).toList();
  }

  static List<Product> _sorted(List<Product> products) {
    final sorted = [...products];
    sorted.sort((a, b) {
      if (a.isFeatured != b.isFeatured) {
        return a.isFeatured ? -1 : 1;
      }
      final salesCompare = b.salesCount.compareTo(a.salesCount);
      if (salesCompare != 0) return salesCompare;
      return a.name.compareTo(b.name);
    });
    return sorted;
  }
}
