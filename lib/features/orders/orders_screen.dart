import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/order_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My orders')),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet. Your orders will appear here.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(child: ListTile(
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text('Order #' + order.id.substring(order.id.length - 6)),
                  subtitle: Text(order.items.length.toString() + ' products'),
                  trailing: Text(r'$' + order.total.toStringAsFixed(2)),
                ));
              },
            ),
    );
  }
}
