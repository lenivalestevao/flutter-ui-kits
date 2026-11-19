import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'shop_data.dart';

/// Shopping cart with quantity steppers, a promo code and order summary.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _code = TextEditingController();
  String? _codeMessage;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _apply() {
    final ok = cart.applyCode(_code.text);
    setState(() {
      _codeMessage = ok ? 'Code applied: 10% off' : 'Invalid code. Try SAVE10';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your cart')),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.lines.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Text('Your cart is empty', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Keep shopping'),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  children: [
                    for (final line in cart.lines) ...[
                      _CartRow(line: line),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _code,
                            textCapitalization: TextCapitalization.characters,
                            decoration: fieldDecoration(context, 'Promo code', Icons.sell_outlined),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 56,
                          child: FilledButton.tonal(onPressed: _apply, child: const Text('Apply')),
                        ),
                      ],
                    ),
                    if (_codeMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: Text(
                          _codeMessage!,
                          style: TextStyle(
                            color: cart.hasDiscount ? AppThemeColors.success : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    AppCard(
                      child: Column(
                        children: [
                          _SummaryRow('Subtotal', money(cart.subtotal)),
                          if (cart.hasDiscount) _SummaryRow('Discount', '-${money(cart.discount)}'),
                          _SummaryRow('Shipping', cart.shipping == 0 ? 'Free' : money(cart.shipping)),
                          const Divider(height: 24),
                          _SummaryRow('Total', money(cart.total), bold: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (_) => const CheckoutScreen()),
                        );
                      },
                      child: Text(
                        'Checkout  ·  ${money(cart.total)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Colors that are not part of the Material scheme.
class AppThemeColors {
  AppThemeColors._();

  static const Color success = Color(0xFF16A34A);
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 18 : 14,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final p = line.product;
    return AppCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          GradientTile(
            hue: p.hue,
            width: 76,
            height: 76,
            radius: 14,
            child: Text(p.emoji, style: const TextStyle(fontSize: 34)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                Text('Size ${line.size}', style: text.bodySmall?.copyWith(color: context.muted)),
                const SizedBox(height: 6),
                Text(money(p.price * line.qty), style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => cart.setQty(line, line.qty - 1),
                    icon: Icon(line.qty == 1 ? Icons.delete_outline : Icons.remove),
                  ),
                  Text('${line.qty}', style: const TextStyle(fontWeight: FontWeight.w800)),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => cart.setQty(line, line.qty + 1),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple checkout form. It validates the fields and shows a success page.
/// It does not charge anything: connect your payment provider here.
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _done = false;
  double _paid = 0;

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _email(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Required';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value) ? null : 'Enter a valid email';
  }

  void _pay() {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _paid = cart.total;
      _done = true;
    });
    cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  Text(
                    'Order placed!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Demo order for ${money(_paid)}. No payment was made.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.muted),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    child: const Text('Back to home'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            TextFormField(
              validator: _required,
              textInputAction: TextInputAction.next,
              decoration: fieldDecoration(context, 'Full name', Icons.person_outline),
            ),
            const SizedBox(height: 12),
            TextFormField(
              validator: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: fieldDecoration(context, 'Email', Icons.mail_outline),
            ),
            const SizedBox(height: 12),
            TextFormField(
              validator: _required,
              textInputAction: TextInputAction.next,
              decoration: fieldDecoration(context, 'Address', Icons.home_outlined),
            ),
            const SizedBox(height: 12),
            TextFormField(
              validator: _required,
              keyboardType: TextInputType.number,
              decoration: fieldDecoration(context, 'Card number (demo)', Icons.credit_card),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: _pay,
                child: Text(
                  'Pay ${money(cart.total)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
