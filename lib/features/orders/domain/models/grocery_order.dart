import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../cart/domain/models/cart_state.dart';

enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }

class OrderLine {
  const OrderLine({required this.productId, required this.name, required this.quantity, required this.unitPriceCents});
  final String productId;
  final String name;
  final int quantity;
  final int unitPriceCents;
  int get totalCents => unitPriceCents * quantity;

  factory OrderLine.fromCartItem(CartItem item) => OrderLine(
    productId: item.product.id, name: item.product.name, quantity: item.quantity,
    unitPriceCents: (item.product.price * 100).round(),
  );
  Map<String, dynamic> toMap() => {
    'productId': productId, 'name': name, 'quantity': quantity, 'unitPriceCents': unitPriceCents,
  };
  factory OrderLine.fromMap(Map<String, dynamic> value) => OrderLine(
    productId: value['productId'] as String? ?? '',
    name: value['name'] as String? ?? '',
    quantity: (value['quantity'] as num?)?.toInt() ?? 0,
    unitPriceCents: (value['unitPriceCents'] as num?)?.toInt() ?? 0,
  );
}

class DeliveryAddress {
  const DeliveryAddress({required this.recipient, required this.phone, required this.street, required this.city, required this.state, this.notes = ''});
  final String recipient, phone, street, city, state, notes;
  Map<String, dynamic> toMap() => {'recipient':recipient,'phone':phone,'street':street,'city':city,'state':state,'notes':notes};
  factory DeliveryAddress.fromMap(Map<String, dynamic> v) => DeliveryAddress(
    recipient:v['recipient'] as String? ?? '',phone:v['phone'] as String? ?? '',
    street:v['street'] as String? ?? '',city:v['city'] as String? ?? '',
    state:v['state'] as String? ?? '',notes:v['notes'] as String? ?? '',
  );
}

class GroceryOrder {
  const GroceryOrder({required this.id, required this.userId, required this.items,
    required this.address, required this.subtotalCents, required this.deliveryFeeCents,
    required this.createdAt, this.status = OrderStatus.pending});
  final String id, userId;
  final List<OrderLine> items;
  final DeliveryAddress address;
  final int subtotalCents, deliveryFeeCents;
  final DateTime createdAt;
  final OrderStatus status;
  int get totalCents => subtotalCents + deliveryFeeCents;
  double get total => totalCents / 100;
  Map<String,dynamic> toMap() => {
    'userId':userId,'items':items.map((item)=>item.toMap()).toList(),
    'address':address.toMap(),'subtotalCents':subtotalCents,
    'deliveryFeeCents':deliveryFeeCents, 'totalCents':totalCents,
    'createdAt':Timestamp.fromDate(createdAt),'status':status.name,
    'paymentMethod':'payOnDelivery',
  };
  factory GroceryOrder.fromDocument(DocumentSnapshot<Map<String,dynamic>> doc) {
    final data=doc.data() ?? {};
    final statusText=data['status'] as String? ?? 'pending';
    return GroceryOrder(
      id:doc.id, userId:data['userId'] as String? ?? '',
      items:(data['items'] as List<dynamic>? ?? []).map((v)=>OrderLine.fromMap(Map<String,dynamic>.from(v as Map))).toList(),
      address:DeliveryAddress.fromMap(Map<String,dynamic>.from(data['address'] as Map? ?? {})),
      subtotalCents:(data['subtotalCents'] as num?)?.toInt() ?? 0,
      deliveryFeeCents:(data['deliveryFeeCents'] as num?)?.toInt() ?? 0,
      createdAt:(data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
      status:OrderStatus.values.firstWhere((v)=>v.name==statusText,orElse:()=>OrderStatus.pending),
    );
  }
}
