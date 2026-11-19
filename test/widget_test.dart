import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ui_kits/main.dart';
import 'package:flutter_ui_kits/shop/shop_data.dart';

void main() {
  testWidgets('gallery lists the four kits', (tester) async {
    await tester.pumpWidget(const UiKitsApp());
    expect(find.text('Onboarding'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  test('cart totals, free shipping and promo code', () {
    final model = CartModel();
    model.add(products.first, 'M', 1);
    expect(model.count, 1);
    expect(model.shipping, 7.99);
    model.add(products.first, 'M', 1);
    expect(model.count, 2);
    expect(model.shipping, 0);
    expect(model.applyCode('nope'), isFalse);
    expect(model.applyCode('save10'), isTrue);
    expect(model.total, closeTo(products.first.price * 2 * 0.9, 0.001));
  });
}
