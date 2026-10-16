import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/providers/order_providers.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync=ref.watch(ordersProvider);
    return Scaffold(
      appBar:AppBar(title:const Text('My orders')),
      body:ordersAsync.when(
        loading:()=>const Center(child:CircularProgressIndicator()),
        error:(error,_)=>Center(child:Padding(
          padding:const EdgeInsets.all(20),
          child:Text('Could not load orders: $error',textAlign:TextAlign.center))),
        data:(orders)=>orders.isEmpty
          ? const Center(child:Text('No orders yet. Complete checkout to see your orders.'))
          : ListView.builder(
            padding:const EdgeInsets.all(16),
            itemCount:orders.length,
            itemBuilder:(context,index) {
              final order=orders[index];
              return Card(child:ListTile(
                leading:const Icon(Icons.receipt_long_outlined),
                title:Text('Order #${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0)}'),
                subtitle:Text('${order.items.length} products • ${order.status.name}'),
                trailing:Text('\$${order.total.toStringAsFixed(2)}'),
              ));
            },
          ),
      ),
    );
  }
}
