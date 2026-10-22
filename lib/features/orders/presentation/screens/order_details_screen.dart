import 'package:flutter/material.dart';
import '../../domain/models/grocery_order.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});
  final GroceryOrder order;
  @override
  Widget build(BuildContext context) {
    final address = order.address;
    return Scaffold(
      appBar: AppBar(title: const Text('Order details')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text('Order #' + order.id, style: Theme.of(context).textTheme.titleMedium),
        Chip(label: Text('Status: ' + order.status.name)),
        Text('Placed: ' + order.createdAt.toLocal().toString()),
        const SizedBox(height: 20),
        Text('Items', style: Theme.of(context).textTheme.titleLarge),
        for (final item in order.items)
          ListTile(
            title: Text(item.name),
            subtitle: Text('Quantity: ' + item.quantity.toString()),
            trailing: Text(r'$' + (item.totalCents / 100).toStringAsFixed(2)),
          ),
        const Divider(),
        Text('Subtotal: ' + r'$' + (order.subtotalCents / 100).toStringAsFixed(2)),
        Text('Delivery: ' + r'$' + (order.deliveryFeeCents / 100).toStringAsFixed(2)),
        Text('Total: ' + r'$' + order.total.toStringAsFixed(2),
          style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 20),
        Text('Delivery address', style: Theme.of(context).textTheme.titleLarge),
        Text(address.recipient),
        Text(address.phone),
        Text([address.street,address.city,address.state].join(', ')),
        if (address.notes.isNotEmpty) Text('Notes: ' + address.notes),
        const SizedBox(height: 20),
        const Text('Payment method: Pay on delivery'),
      ]),
    );
  }
}
