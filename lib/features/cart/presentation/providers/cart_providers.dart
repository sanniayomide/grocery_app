import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/cart_state.dart';
import '../../../catalog/domain/models/product.dart';

final cartNotifierProvider = StateNotifierProvider<CartNotifier, CartState>((
  ref,
) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addProduct(Product product, {int quantity = 1}) {
    final existing = state.findByProductId(product.id);
    if (existing == null) {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(product: product, quantity: quantity),
        ],
      );
      return;
    }

    updateQuantity(product.id, existing.quantity + quantity);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }

    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.product.id == productId)
            item.copyWith(quantity: quantity)
          else
            item,
      ],
    );
  }

  void removeProduct(String productId) {
    state = state.copyWith(
      items: state.items
          .where((item) => item.product.id != productId)
          .toList(growable: false),
    );
  }

  void clearCart() {
    state = const CartState();
  }
}
