import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/order_repository.dart';
import '../../domain/models/grocery_order.dart';

final orderRepositoryProvider=Provider<OrderRepository>((ref)=>OrderRepository(
  firestore: FirebaseFirestore.instance, auth:FirebaseAuth.instance,
));

final ordersProvider=StreamProvider.autoDispose<List<GroceryOrder>>((ref) {
  final auth=FirebaseAuth.instance;
  final controller=ref.watch(orderRepositoryProvider);
  return auth.authStateChanges().asyncExpand((user) =>
    user==null ? Stream.value(const <GroceryOrder>[]) : controller.watchMyOrders(),
  );
});
