// Home tab: search, category chips, product grid (GrocerApp-style).
import 'package:flutter/material.dart';
import '../data/products.dart';
import '../state/app_state.dart';
import '../ui.dart';
import 'product_detail.dart';

class HomeScreen extends StatefulWidget {
  final AppState state;
  const HomeScreen({super.key, required this.state});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = "";
  String _cat = "sab";
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Product> get _visible {
    final ids = kCategories[_cat]!;
    final q = _query.trim().toLowerCase();
    return kProducts.where((p) {
      if (!ids.contains(p.id)) return false;
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) ||
          p.roman.toLowerCase().contains(q);
    }).toList();
  }

  void _openSheet(Product p) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(state: widget.state, product: p),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          "assets/images/logo.webp",
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Sabzi Fresh",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: kGreenDark)),
                          Text("Sadam Hussain Sabzi Farosh",
                              style:
                                  TextStyle(fontSize: 13, color: kMuted)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: "Naam se dhoondo...",
                      prefixIcon: const Icon(Icons.search, color: kMuted),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: kLine),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: kLine),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: kCategoryLabels.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final id = kCategoryLabels.keys.elementAt(i);
                        final selected = id == _cat;
                        return ChoiceChip(
                          label: Text(kCategoryLabels[id]!),
                          selected: selected,
                          onSelected: (_) => setState(() => _cat = id),
                          selectedColor: kGreen,
                          labelStyle: TextStyle(
                              color: selected ? Colors.white : kInk,
                              fontWeight: FontWeight.w600),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: kLine),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SectionHeader("Fresh Arrivals")),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.70,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) {
                  final p = _visible[i];
                  return _ProductCard(
                      state: widget.state,
                      product: p,
                      onTap: () => _openSheet(p));
                },
                childCount: _visible.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final AppState state;
  final Product product;
  final VoidCallback onTap;
  const _ProductCard(
      {required this.state, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final available = state.inStock(product.id);
    final inCart =
        state.cart.any((e) => e.id == product.id);
    return GestureDetector(
      onTap: available ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kLine),
          boxShadow: kCardShadows,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18)),
                    child: Image.asset(
                      "assets/images/item-${product.id}.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (!available)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.72),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: kInk,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("Khatam",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  const RateText(size: 14),
                  Text("fi ${product.unit}",
                      style:
                          const TextStyle(fontSize: 12, color: kMuted)),
                  const SizedBox(height: 8),
                  if (!available)
                    const SizedBox.shrink()
                  else if (!inCart)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text("Tokri mein daalo",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ),
                    )
                  else
                    _CardStepper(
                        state: state, productId: product.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small − qty + stepper shown on the card once the item is in the cart.
class _CardStepper extends StatelessWidget {
  final AppState state;
  final String productId;
  const _CardStepper({required this.state, required this.productId});

  @override
  Widget build(BuildContext context) {
    final lines =
        state.cart.where((e) => e.id == productId).toList();
    if (lines.isEmpty) return const SizedBox.shrink();
    final total = lines.fold(0.0, (a, e) => a + e.wazan);
    final unit = lines.first.unit;
    return Container(
      decoration: BoxDecoration(
        color: kSage,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stepBtn(Icons.remove, () {
            final l = lines.first;
            state.changeWazan(l, -(l.unit == 'kg' ? 0.5 : 1.0));
          }),
          Text(fmtWazan(total, unit),
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: kGreenDark)),
          _stepBtn(Icons.add, () {
            final l = lines.first;
            state.changeWazan(l, (l.unit == 'kg' ? 0.5 : 1.0));
          }),
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
            color: kGreenDark, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
