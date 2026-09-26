import '../../../cart/domain/models/cart_state.dart';

class GroceryOrder {
  const GroceryOrder({
    required this.id, required this.items, required this.subtotal,
    required this.deliveryFee, required this.createdAt,
  });
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final DateTime createdAt;
  double get total => subtotal + deliveryFee;
}
