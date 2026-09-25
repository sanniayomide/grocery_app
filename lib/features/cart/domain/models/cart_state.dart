import '../../../catalog/domain/models/product.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
  });

  final Product product;
  final int quantity;

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartState {
  const CartState({
    this.items = const [],
  });

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  int get totalItems {
    return items.fold<int>(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return items.fold<double>(0, (sum, item) => sum + item.totalPrice);
  }

  double get deliveryFee => isEmpty ? 0 : 4.99;

  double get total => subtotal + deliveryFee;

  CartItem? findByProductId(String productId) {
    for (final item in items) {
      if (item.product.id == productId) return item;
    }
    return null;
  }

  CartState copyWith({
    List<CartItem>? items,
  }) {
    return CartState(items: items ?? this.items);
  }
}
