import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'cart_screen.dart';
import 'shop_data.dart';

/// Product page with size picker, quantity stepper and "Add to cart".
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _size = 'M';
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final text = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
            },
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          GradientTile(
            hue: p.hue,
            radius: 28,
            height: 280,
            child: Text(p.emoji, style: const TextStyle(fontSize: 110)),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(p.name, style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              ),
              Text(money(p.price), style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Pill(p.category),
              const SizedBox(width: 10),
              const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF5A623)),
              Text(' ${p.rating} (${p.reviews} reviews)', style: TextStyle(color: context.muted)),
            ],
          ),
          const SizedBox(height: 16),
          Text(p.description, style: text.bodyMedium?.copyWith(color: context.muted, height: 1.5)),
          const SizedBox(height: 20),
          Text('Size', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final s in sizes)
                ChoiceChip(
                  label: Text(s),
                  selected: s == _size,
                  onSelected: (_) => setState(() => _size = s),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('Quantity', style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              const Spacer(),
              IconButton.outlined(
                onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '$_qty',
                  textAlign: TextAlign.center,
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              IconButton.outlined(
                onPressed: () => setState(() => _qty++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () {
                cart.add(p, _size, _qty);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added $_qty x ${p.name} to your cart')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: Text(
                'Add to cart  ·  ${money(p.price * _qty)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
