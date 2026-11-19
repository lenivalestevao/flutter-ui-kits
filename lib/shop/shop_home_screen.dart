import 'package:flutter/material.dart';

import '../widgets/common.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';
import 'shop_data.dart';

/// Store home: search, category chips, promo banner and a product grid.
class ShopHomeScreen extends StatefulWidget {
  const ShopHomeScreen({super.key});

  @override
  State<ShopHomeScreen> createState() => _ShopHomeScreenState();
}

class _ShopHomeScreenState extends State<ShopHomeScreen> {
  String _category = 'All';
  String _query = '';
  final Set<int> _favorites = {};

  List<Product> get _visible {
    return products.where((p) {
      final okCategory = _category == 'All' || p.category == _category;
      final okQuery = _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase());
      return okCategory && okQuery;
    }).toList();
  }

  void _openCart() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final items = _visible;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aurelia', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          ListenableBuilder(
            listenable: cart,
            builder: (context, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: IconButton(
                  tooltip: 'Cart',
                  onPressed: _openCart,
                  icon: Badge(
                    isLabelVisible: cart.count > 0,
                    label: Text('${cart.count}'),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: fieldDecoration(context, 'Search products', Icons.search),
          ),
          const SizedBox(height: 16),
          GradientTile(
            hue: 260,
            radius: 22,
            height: 130,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Spring sale',
                          style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Use code SAVE10 at checkout',
                          style: text.bodyMedium?.copyWith(color: context.muted),
                        ),
                      ],
                    ),
                  ),
                  const Text('🛍️', style: TextStyle(fontSize: 52)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final c = categories[i];
                return ChoiceChip(
                  label: Text(c),
                  selected: c == _category,
                  onSelected: (_) => setState(() => _category = c),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SectionHeader('Popular (${items.length})'),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text('No products found', style: TextStyle(color: context.muted)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.74,
              ),
              itemBuilder: (context, i) {
                final p = items[i];
                return _ProductCard(
                  product: p,
                  favorite: _favorites.contains(p.id),
                  onFavorite: () {
                    setState(() {
                      if (!_favorites.remove(p.id)) _favorites.add(p.id);
                    });
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => ProductDetailScreen(product: p)),
                    );
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.favorite,
    required this.onFavorite,
    required this.onTap,
  });

  final Product product;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.all(10),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                GradientTile(
                  hue: product.hue,
                  radius: 12,
                  width: double.infinity,
                  child: Text(product.emoji, style: const TextStyle(fontSize: 48)),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: InkResponse(
                    onTap: onFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: context.card, shape: BoxShape.circle),
                      child: Icon(
                        favorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: favorite ? Colors.redAccent : null,
                      ),
                    ),
                  ),
                ),
                if (product.oldPrice != null)
                  const Positioned(left: 6, top: 6, child: Pill('Sale', color: Colors.redAccent)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF5A623)),
              const SizedBox(width: 2),
              Text('${product.rating}', style: text.bodySmall?.copyWith(color: context.muted)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Text(money(product.price), style: text.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
              if (product.oldPrice != null) ...[
                const SizedBox(width: 6),
                Text(
                  money(product.oldPrice!),
                  style: text.bodySmall?.copyWith(
                    color: context.muted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
