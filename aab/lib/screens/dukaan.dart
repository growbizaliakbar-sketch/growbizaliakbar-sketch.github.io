// Dukaan tab: shop photos, contact buttons, admin entry (PIN).
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/products.dart';
import '../state/app_state.dart';
import '../ui.dart';
import 'admin.dart';

class DukaanScreen extends StatelessWidget {
  final AppState state;
  const DukaanScreen({super.key, required this.state});

  Future<void> _call() async {
    await launchUrl(Uri.parse("tel:$kCallNumber"));
  }

  Future<void> _whatsApp(BuildContext context) async {
    final url =
        "https://wa.me/$kWaNumber?text=${Uri.encodeComponent("Assalam o Alaikum! Mujhe sabzi ka rate chahiye.")}";
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WhatsApp nahi khul saka.")),
        );
      }
    }
  }

  void _askPin(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Admin PIN"),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          decoration: const InputDecoration(
            hintText: "4 huroof ka PIN",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Wapas"),
          ),
          ElevatedButton(
            onPressed: () {
              if (ctrl.text == "1234") {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdminScreen(state: state)),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Ghalat PIN.")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text("Kholo"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Hamari Dukaan",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text("Sadam Hussain Sabzi Farosh",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kGreenDark)),
            const SizedBox(height: 2),
            const Text("تازہ سبزی • مناسب دام",
                style: TextStyle(fontSize: 15, color: kMuted)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  "assets/images/shop-${i + 1}.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _call,
                icon: const Icon(Icons.call, color: kGreenDark),
                label: const Text("0305-5436385 — Sirf Call",
                    style: TextStyle(
                        color: kInk, fontWeight: FontWeight.w700)),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: kGreen, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _whatsApp(context),
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text("0343-7313039 — WhatsApp",
                    style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => _askPin(context),
                child: const Text("Admin",
                    style: TextStyle(color: kMuted, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
