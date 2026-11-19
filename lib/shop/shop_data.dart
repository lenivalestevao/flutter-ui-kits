import 'package:flutter/foundation.dart';

/// Formats a number as a price, for example `$89.00`.
String money(double value) => '\$${value.toStringAsFixed(2)}';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.emoji,
    required this.hue,
    required this.rating,
    required this.reviews,
    required this.description,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String emoji;
  final double hue;
  final double rating;
  final int reviews;
  final String description;
}

const List<String> categories = ['All', 'Shoes', 'Bags', 'Watches', 'Tech'];
const List<String> sizes = ['S', 'M', 'L', 'XL'];

/// Demo catalog. Replace it with data from your own API.
const List<Product> products = [
  Product(
    id: 1,
    name: 'Aero Runner',
    category: 'Shoes',
    price: 89,
    oldPrice: 120,
    emoji: '👟',
    hue: 230,
    rating: 4.8,
    reviews: 214,
    description: 'Lightweight running shoes with a breathable knit upper and a cushioned sole for all-day comfort.',
  ),
  Product(
    id: 2,
    name: 'Urban Backpack',
    category: 'Bags',
    price: 64.5,
    emoji: '🎒',
    hue: 160,
    rating: 4.6,
    reviews: 128,
    description: 'Water-resistant backpack with a padded laptop pocket and plenty of room for your day.',
  ),
  Product(
    id: 3,
    name: 'Classic Watch',
    category: 'Watches',
    price: 199,
    oldPrice: 249,
    emoji: '⌚',
    hue: 30,
    rating: 4.9,
    reviews: 87,
    description: 'A timeless analog watch with a stainless steel case and a soft leather strap.',
  ),
  Product(
    id: 4,
    name: 'Wireless Buds',
    category: 'Tech',
    price: 79,
    emoji: '🎧',
    hue: 280,
    rating: 4.5,
    reviews: 342,
    description: 'True wireless earbuds with active noise cancelling and 24 hours of battery with the case.',
  ),
  Product(
    id: 5,
    name: 'Leather Tote',
    category: 'Bags',
    price: 119,
    emoji: '👜',
    hue: 340,
    rating: 4.7,
    reviews: 65,
    description: 'Roomy tote made from soft vegetable-tanned leather that gets better with age.',
  ),
  Product(
    id: 6,
    name: 'Trail Boots',
    category: 'Shoes',
    price: 139,
    emoji: '🥾',
    hue: 25,
    rating: 4.8,
    reviews: 156,
    description: 'Waterproof hiking boots with grippy soles, built for muddy trails and long days.',
  ),
  Product(
    id: 7,
    name: 'Smart Band',
    category: 'Watches',
    price: 59,
    oldPrice: 79,
    emoji: '⏱️',
    hue: 190,
    rating: 4.4,
    reviews: 410,
    description: 'Fitness band with heart rate, sleep tracking and a bright always-on display.',
  ),
  Product(
    id: 8,
    name: 'Mini Speaker',
    category: 'Tech',
    price: 49,
    emoji: '🔊',
    hue: 50,
    rating: 4.6,
    reviews: 203,
    description: 'Pocket-sized Bluetooth speaker with surprisingly big sound and 12 hours of playtime.',
  ),
];

class CartLine {
  CartLine(this.product, this.size, this.qty);

  final Product product;
  final String size;
  int qty;
}

/// Very small cart model. It is a [ChangeNotifier], so screens can rebuild
/// with a `ListenableBuilder`. Swap it for Provider, Riverpod or Bloc if you
/// prefer.
class CartModel extends ChangeNotifier {
  final List<CartLine> _lines = [];
  double _discountRate = 0;

  List<CartLine> get lines => List<CartLine>.unmodifiable(_lines);

  int get count => _lines.fold<int>(0, (sum, l) => sum + l.qty);

  double get subtotal => _lines.fold<double>(0, (sum, l) => sum + l.product.price * l.qty);

  double get discount => subtotal * _discountRate;

  /// Free shipping from $100.
  double get shipping => (_lines.isEmpty || subtotal >= 100) ? 0 : 7.99;

  double get total => subtotal - discount + shipping;

  bool get hasDiscount => _discountRate > 0;

  /// Returns true when the code is valid. Try `SAVE10`.
  bool applyCode(String code) {
    if (code.trim().toUpperCase() == 'SAVE10') {
      _discountRate = 0.10;
      notifyListeners();
      return true;
    }
    return false;
  }

  void add(Product product, String size, int qty) {
    final i = _lines.indexWhere((l) => l.product.id == product.id && l.size == size);
    if (i >= 0) {
      _lines[i].qty += qty;
    } else {
      _lines.add(CartLine(product, size, qty));
    }
    notifyListeners();
  }

  void setQty(CartLine line, int qty) {
    if (qty <= 0) {
      _lines.remove(line);
    } else {
      line.qty = qty;
    }
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    _discountRate = 0;
    notifyListeners();
  }
}

/// App-wide cart used by the shop screens.
final CartModel cart = CartModel();
