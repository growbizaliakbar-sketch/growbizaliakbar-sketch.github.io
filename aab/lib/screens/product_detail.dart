// Product detail page: big image, name, availability, rate, blue CTA,
// ordering options, about, and a "More Fresh Vegetables" row.
import 'package:flutter/material.dart';
import '../data/products.dart';
import '../state/app_state.dart';
import '../ui.dart';

class ProductDetailPage extends StatefulWidget {
  final AppState state;
  final Product product;
  const ProductDetailPage(
      {super.key, required this.state, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _quality = "VIP";
  double _wazan = 1.0;
  String _cut = "Sabut";

  double get _step => widget.product.unit == 'kg' ? 0.5 : 1.0;

  String get _availability => widget.product.unit == 'kg'
      ? "Available in: fi kg"
      : "Available in: 1 gaddi";

  void _addToTokri() {
    final p = widget.product;
    widget.state.addItem(CartItem(
      id: p.id,
      name: p.name,
      unit: p.unit,
      wazan: _wazan,
      quality: _quality,
      cut: _cut,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("${p.name} tokri mein daal diya!"),
          duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final available = widget.state.inStock(p.id);
    final others = kProducts.where((e) => e.id != p.id).toList();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Big image on white + back button
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 48),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          "assets/images/item-${p.id}.jpg",
                          height: 280,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: kLine),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 8,
                                offset: Offset(0, 2)),
                          ],
                        ),
                        child: const Icon(Icons.arrow_back, color: kInk),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Name
                    Text(p.name,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: kInk)),
                    const SizedBox(height: 6),
                    // 3. Availability
                    Text(_availability,
                        style:
                            const TextStyle(fontSize: 14, color: kMuted)),
                    const SizedBox(height: 8),
                    // 4. Rate
                    const RateText(size: 18),
                    const SizedBox(height: 16),
                    // 5. CTA
                    if (!available)
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: kSage,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text("Khatam — abhi stock mein nahi",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: kGreenDark)),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addToTokri,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text("Tokri mein daalo",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                    if (available) ...[
                      const SizedBox(height: 16),
                      // 6. Ordering options card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kLine),
                          boxShadow: kCardShadows,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _OptLabel("Quality chuno"),
                            _ChipRow(
                              options: const ["VIP", "Normal"],
                              selected: _quality,
                              onPick: (v) =>
                                  setState(() => _quality = v),
                            ),
                            const SizedBox(height: 14),
                            const _OptLabel("Wazan"),
                            Row(
                              children: [
                                _roundBtn(Icons.remove, () {
                                  setState(() {
                                    _wazan = double.parse(
                                        (_wazan - _step).toStringAsFixed(1));
                                    if (_wazan < _step) _wazan = _step;
                                  });
                                }),
                                SizedBox(
                                  width: 90,
                                  child: Text(fmtWazan(_wazan, p.unit),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800)),
                                ),
                                _roundBtn(Icons.add, () {
                                  setState(() {
                                    _wazan = double.parse(
                                        (_wazan + _step).toStringAsFixed(1));
                                    if (_wazan > 50) _wazan = 50;
                                  });
                                }),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const _OptLabel("Kat-peet?"),
                            _ChipRow(
                              options: const [
                                "Sabut",
                                "Kati Hui",
                                "Chheeli Hui"
                              ],
                              selected: _cut,
                              onPick: (v) => setState(() => _cut = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    // 7. About
                    const Text("About this item",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kInk)),
                    const SizedBox(height: 6),
                    Text(p.about,
                        style:
                            const TextStyle(fontSize: 14, color: kMuted)),
                    const SizedBox(height: 20),
                    // 8. More Fresh Vegetables
                    const Text("More Fresh Vegetables",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kInk)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 210,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: others.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final o = others[i];
                          return _MoreCard(
                            product: o,
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProductDetailPage(
                                    state: widget.state, product: o),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kLine, width: 1.5),
        ),
        child: Icon(icon, color: kGreenDark),
      ),
    );
  }
}

class _OptLabel extends StatelessWidget {
  final String text;
  const _OptLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text.toUpperCase(),
          style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: kMuted)),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onPick;
  const _ChipRow(
      {required this.options, required this.selected, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: options.map((o) {
        final sel = o == selected;
        return ChoiceChip(
          label: Text(o),
          selected: sel,
          onSelected: (_) => onPick(o),
          selectedColor: kGreen,
          labelStyle: TextStyle(
              color: sel ? Colors.white : kInk,
              fontWeight: FontWeight.w600),
          backgroundColor: Colors.white,
          side: BorderSide(color: sel ? kGreen : kLine),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      }).toList(),
    );
  }
}

/// Compact card for the "More Fresh Vegetables" row.
class _MoreCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const _MoreCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kLine),
          boxShadow: kCardShadows,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.asset(
                "assets/images/item-${product.id}.jpg",
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  const RateText(size: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
