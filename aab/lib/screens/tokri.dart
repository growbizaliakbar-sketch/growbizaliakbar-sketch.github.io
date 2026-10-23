// Tokri tab: cart list, "Kul Rate: ??", area field, WhatsApp send.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/products.dart';
import '../state/app_state.dart';
import '../ui.dart';

class TokriScreen extends StatefulWidget {
  final AppState state;
  const TokriScreen({super.key, required this.state});

  @override
  State<TokriScreen> createState() => _TokriScreenState();
}

class _TokriScreenState extends State<TokriScreen> {
  final _areaCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _areaCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendWhatsApp() async {
    final state = widget.state;
    if (state.cart.isEmpty) return;
    setState(() => _sending = true);
    final area = _areaCtrl.text.trim();
    final buf = StringBuffer("Assalam o Alaikum! Mujhe aaj ka rate chahiye:");
    for (var i = 0; i < state.cart.length; i++) {
      final e = state.cart[i];
      buf.write(
          "\n${i + 1}. ${e.name} — ${fmtWazan(e.wazan, e.unit)} (${e.quality}, ${e.cut})");
    }
    buf.write("\nIlaqa: ${area.isEmpty ? "—" : area}");
    await state.checkout(area);
    final url =
        "https://wa.me/$kWaNumber?text=${Uri.encodeComponent(buf.toString())}";
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WhatsApp nahi khul saka.")),
        );
      }
    }
    if (mounted) setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text("Apni Tokri",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: state.cart.isEmpty
                ? const Center(
                    child: Text("Tokri khaali hai.",
                        style: TextStyle(fontSize: 16, color: kMuted)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: state.cart.length,
                    itemBuilder: (_, i) {
                      final e = state.cart[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kLine),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/images/item-${e.id}.jpg",
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(e.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          subtitle: Text(
                              "${e.quality} • ${e.cut}",
                              style: const TextStyle(
                                  fontSize: 12, color: kMuted)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _qtyBtn(Icons.remove, () {
                                state.changeWazan(
                                    e, -(e.unit == 'kg' ? 0.5 : 1.0));
                              }),
                              SizedBox(
                                width: 64,
                                child: Text(fmtWazan(e.wazan, e.unit),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13)),
                              ),
                              _qtyBtn(Icons.add, () {
                                state.changeWazan(
                                    e, (e.unit == 'kg' ? 0.5 : 1.0));
                              }),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: kMuted),
                                onPressed: () => state.removeItem(e),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: RateText(size: 16)),
                const SizedBox(height: 10),
                TextField(
                  controller: _areaCtrl,
                  decoration: InputDecoration(
                    hintText: "Apna ilaqa likhein (misal: DHA, Gulberg)",
                    filled: true,
                    fillColor: kBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kLine),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kLine),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed:
                      (state.cart.isEmpty || _sending) ? null : _sendWhatsApp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _sending
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text("WhatsApp par Rate Puchein",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: kLine, width: 1.5),
        ),
        child: Icon(icon, size: 16, color: kGreenDark),
      ),
    );
  }
}
