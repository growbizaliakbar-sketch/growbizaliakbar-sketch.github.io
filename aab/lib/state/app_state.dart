// Sabzi Fresh — app state: cart, stock on/off, order history.
// Persisted with shared_preferences. No login, no backend.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/products.dart';

class CartItem {
  final String id;
  final String name;
  final String unit;
  final String quality;
  final String cut;
  double wazan;
  CartItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.wazan,
    required this.quality,
    required this.cut,
  });
}

class AppState extends ChangeNotifier {
  final SharedPreferences prefs;
  AppState(this.prefs);

  // product id -> in stock (default true)
  Map<String, bool> stock = {};
  final List<CartItem> cart = [];
  // newest first: {ts: int ms, area: String, lines: List<String>}
  List<Map<String, dynamic>> orders = [];

  Future<void> load() async {
    final s = prefs.getString('sf_stock');
    if (s != null) {
      try {
        final m = jsonDecode(s) as Map<String, dynamic>;
        stock = m.map((k, v) => MapEntry(k, v as bool));
      } catch (_) {}
    }
    final o = prefs.getString('sf_orders');
    if (o != null) {
      try {
        orders = (jsonDecode(o) as List).cast<Map<String, dynamic>>();
      } catch (_) {}
    }
    notifyListeners();
  }

  bool inStock(String id) => stock[id] ?? true;

  Future<void> setStock(String id, bool value) async {
    stock[id] = value;
    await prefs.setString('sf_stock', jsonEncode(stock));
    notifyListeners();
  }

  void addItem(CartItem item) {
    for (final e in cart) {
      if (e.id == item.id && e.quality == item.quality && e.cut == item.cut) {
        e.wazan += item.wazan;
        notifyListeners();
        return;
      }
    }
    cart.add(item);
    notifyListeners();
  }

  void changeWazan(CartItem item, double delta) {
    final step = item.unit == 'kg' ? 0.5 : 1.0;
    item.wazan = double.parse((item.wazan + delta).toStringAsFixed(1));
    if (item.wazan < step) {
      cart.remove(item);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    cart.remove(item);
    notifyListeners();
  }

  int get cartCount => cart.length;

  /// Save current cart as an order in local history and clear the cart.
  /// Returns the order lines (for the WhatsApp message).
  Future<List<String>> checkout(String area) async {
    final lines = <String>[];
    for (var i = 0; i < cart.length; i++) {
      final e = cart[i];
      lines.add(
          "${i + 1}. ${e.name} — ${fmtWazan(e.wazan, e.unit)} (${e.quality}, ${e.cut})");
    }
    orders.insert(0, {
      'ts': DateTime.now().millisecondsSinceEpoch,
      'area': area,
      'lines': lines,
    });
    await prefs.setString('sf_orders', jsonEncode(orders));
    cart.clear();
    notifyListeners();
    return lines;
  }
}

String fmtOrderDate(int ms) {
  final d = DateTime.fromMillisecondsSinceEpoch(ms);
  final hh = d.hour.toString().padLeft(2, '0');
  final mm = d.minute.toString().padLeft(2, '0');
  return "${d.day}/${d.month}/${d.year}  $hh:$mm";
}
