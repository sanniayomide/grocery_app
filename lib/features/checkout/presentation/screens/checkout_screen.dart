import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../cart/presentation/providers/cart_providers.dart';
import '../../../orders/domain/models/grocery_order.dart';
import '../../../orders/presentation/providers/order_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});
  @override
  ConsumerState<CheckoutScreen> createState()=>_CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _form=GlobalKey<FormState>();
  final _recipient=TextEditingController();
  final _phone=TextEditingController();
  final _street=TextEditingController();
  final _city=TextEditingController();
  final _state=TextEditingController();
  final _notes=TextEditingController();
  bool _submitting=false;

  @override
  void dispose() {
    for(final c in [_recipient,_phone,_street,_city,_state,_notes]) { c.dispose(); }
    super.dispose();
  }

  String? _required(String? v) => (v?.trim().isEmpty ?? true) ? 'This field is required' : null;

  Future<void> _submit() async {
    if(_submitting || !(_form.currentState?.validate() ?? false)) return;
    final cart=ref.read(cartNotifierProvider);
    if(cart.isEmpty) return;
    final user=FirebaseAuth.instance.currentUser;
    if(user==null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Please sign in first.')));
      return;
    }
    setState(()=>_submitting=true);
    try {
      final lines=cart.items.map(OrderLine.fromCartItem).toList(growable:false);
      final subtotal=lines.fold<int>(0,(value,line)=>value+line.totalCents);
      final order=GroceryOrder(
        id:FirebaseFirestoreOrderId.newId(),
        userId:user.uid,items:lines,
        address:DeliveryAddress(
          recipient:_recipient.text.trim(),phone:_phone.text.trim(),
          street:_street.text.trim(),city:_city.text.trim(),
          state:_state.text.trim(),notes:_notes.text.trim(),
        ),
        subtotalCents:subtotal,
        deliveryFeeCents:(cart.deliveryFee*100).round(),
        createdAt:DateTime.now().toUtc(),
      );
      await ref.read(orderRepositoryProvider).submit(order);
      ref.read(cartNotifierProvider.notifier).clearCart();
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text('Order placed! Pay on delivery.')),
      );
      Navigator.of(context).pop(true);
    } catch(error) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:Text('Order not completed: $error')),
      );
    } finally {
      if(mounted) setState(()=>_submitting=false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart=ref.watch(cartNotifierProvider);
    return Scaffold(
      appBar:AppBar(title:const Text('Checkout')),
      body:SafeArea(child:Form(key:_form,child:ListView(
        padding:const EdgeInsets.all(20),
        children:[
          Text('Delivery details',style:Theme.of(context).textTheme.titleLarge),
          const SizedBox(height:12),
          TextFormField(controller:_recipient,decoration:const InputDecoration(labelText:'Full name'),validator:_required),
          TextFormField(controller:_phone,keyboardType:TextInputType.phone,decoration:const InputDecoration(labelText:'Phone number'),validator:(v) {
            final digits=(v??'').replaceAll(RegExp(r'\D'),'');
            return digits.length<10 || digits.length>15 ? 'Enter a valid phone number' : null;
          }),
          TextFormField(controller:_street,decoration:const InputDecoration(labelText:'Street address'),validator:_required),
          TextFormField(controller:_city,decoration:const InputDecoration(labelText:'City'),validator:_required),
          TextFormField(controller:_state,decoration:const InputDecoration(labelText:'State'),validator:_required),
          TextFormField(controller:_notes,decoration:const InputDecoration(labelText:'Delivery notes (optional)')),
          const SizedBox(height:20),
          Text('Order summary',style:Theme.of(context).textTheme.titleLarge),
          for(final item in cart.items) ListTile(
            title:Text(item.product.name),subtitle:Text('Qty: ${item.quantity}'),
            trailing:Text('\$${item.totalPrice.toStringAsFixed(2)}'),
          ),
          const Divider(),
          Text('Subtotal: \$${cart.subtotal.toStringAsFixed(2)}'),
          Text('Delivery: \$${cart.deliveryFee.toStringAsFixed(2)}'),
          Text('Total: \$${cart.total.toStringAsFixed(2)}',style:Theme.of(context).textTheme.titleMedium),
          const SizedBox(height:12),
          const Text('Payment: Pay on delivery (no online payment).'),
          const SizedBox(height:20),
          FilledButton(onPressed:cart.isEmpty || _submitting ? null : _submit,
            child:_submitting ? const SizedBox(height:20,width:20,child:CircularProgressIndicator(strokeWidth:2)) : const Text('Confirm order')),
        ],
      ))),
    );
  }
}

class FirebaseFirestoreOrderId {
  static String newId() => '${DateTime.now().microsecondsSinceEpoch}-${FirebaseAuth.instance.currentUser!.uid.substring(0, 5)}';
}
