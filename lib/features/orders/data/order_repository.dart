import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/models/grocery_order.dart';

class OrderRepository {
  OrderRepository({required FirebaseFirestore firestore, required FirebaseAuth auth})
    : _firestore=firestore, _auth=auth;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  String get _uid {
    final uid=_auth.currentUser?.uid;
    if(uid==null) throw StateError('Sign in to place an order.');
    return uid;
  }
  CollectionReference<Map<String,dynamic>> _orders(String uid) =>
      _firestore.collection('users').doc(uid).collection('orders');

  Stream<List<GroceryOrder>> watchMyOrders() {
    final uid=_auth.currentUser?.uid;
    if(uid==null) return Stream.value(const <GroceryOrder>[]);
    return _orders(uid).orderBy('createdAt',descending:true).snapshots().map(
      (snapshot)=>snapshot.docs.map(GroceryOrder.fromDocument).toList(),
    );
  }

  Future<GroceryOrder> submit(GroceryOrder order) async {
    final uid=_uid;
    if(order.userId!=uid) throw StateError('Order owner mismatch.');
    if(order.items.isEmpty || order.items.any((item)=>item.quantity<=0 || item.unitPriceCents<0)) {
      throw StateError('Invalid cart items.');
    }
    final doc=_orders(uid).doc(order.id);
    await doc.set(order.toMap());
    return order;
  }
}
