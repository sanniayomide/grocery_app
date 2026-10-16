import 'package:flutter_test/flutter_test.dart';
import 'package:grocery_app/features/orders/domain/models/grocery_order.dart';

void main() {
  test('order lines retain integer cents and calculate totals', () {
    const item=OrderLine(productId:'apple',name:'Apple',quantity:3,unitPriceCents:249);
    expect(item.totalCents,747);
    final roundTrip=OrderLine.fromMap(item.toMap());
    expect(roundTrip.quantity,3);
    expect(roundTrip.unitPriceCents,249);
  });
  test('delivery address serialization round trip', () {
    const address=DeliveryAddress(recipient:'Sam',phone:'08012345678',
      street:'1 Market Street',city:'Lagos',state:'Lagos',notes:'Ring bell');
    final restored=DeliveryAddress.fromMap(address.toMap());
    expect(restored.street,address.street);
    expect(restored.notes,'Ring bell');
  });
}
