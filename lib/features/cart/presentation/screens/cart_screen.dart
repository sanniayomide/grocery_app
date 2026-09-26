import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_providers.dart';
import '../../../orders/presentation/providers/order_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My cart')),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty. Add something fresh!'))
          : ListView(padding: const EdgeInsets.all(16), children: [
              for (final item in cart.items)
                Card(child: ListTile(
                  leading: Text(item.product.emojiFallback,
                    style: const TextStyle(fontSize: 32)),
                  title: Text(item.product.name),
                  subtitle: Text(r'$' + item.totalPrice.toStringAsFixed(2)),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      onPressed: () => ref.read(cartNotifierProvider.notifier)
                        .updateQuantity(item.product.id, item.quantity - 1),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(item.quantity.toString()),
                    IconButton(
                      onPressed: () => ref.read(cartNotifierProvider.notifier)
                        .updateQuantity(item.product.id, item.quantity + 1),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ]),
                )),
              const SizedBox(height: 16),
              Text('Subtotal: ' + r'$' + cart.subtotal.toStringAsFixed(2)),
              Text('Delivery: ' + r'$' + cart.deliveryFee.toStringAsFixed(2)),
              const Divider(),
              Text('Total: ' + r'$' + cart.total.toStringAsFixed(2),
                style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ref.read(ordersProvider.notifier).placeOrder(cart);
                  ref.read(cartNotifierProvider.notifier).clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demo order placed. Open Orders to view it.')),
                  );
                },
                child: const Text('Place demo order'),
              ),
            ]),
    );
  }
}
