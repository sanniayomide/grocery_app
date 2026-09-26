import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/product.dart';
import '../../../cart/presentation/providers/cart_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: Text(product.name)),
    body: ListView(padding: const EdgeInsets.all(24), children: [
      Center(child: Text(product.emojiFallback, style: const TextStyle(fontSize: 96))),
      Text(product.name, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 12),
      Text(product.description),
      const SizedBox(height: 12),
      Text(r'$' + product.price.toStringAsFixed(2) + ' / ' + product.unitLabel),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: product.inStock ? () {
          ref.read(cartNotifierProvider.notifier).addProduct(product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(product.name + ' added to cart')),
          );
        } : null,
        icon: const Icon(Icons.add_shopping_cart),
        label: Text(product.inStock ? 'Add to cart' : 'Out of stock'),
      ),
    ]),
  );
}
