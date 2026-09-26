import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cart/domain/models/cart_state.dart';
import '../../domain/models/grocery_order.dart';

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<GroceryOrder>>(
  (ref) => OrdersNotifier(),
);
class OrdersNotifier extends StateNotifier<List<GroceryOrder>> {
  OrdersNotifier() : super(const []);
  GroceryOrder placeOrder(CartState cart) {
    if (cart.isEmpty) throw StateError('Cannot place an empty order');
    final now = DateTime.now();
    final order = GroceryOrder(
      id: now.microsecondsSinceEpoch.toString(),
      items: List.unmodifiable(cart.items),
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      createdAt: now,
    );
    state = [order, ...state];
    return order;
  }
}
