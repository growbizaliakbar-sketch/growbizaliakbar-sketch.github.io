// Admin screen (PIN 1234): stock ON/OFF per product.
import 'package:flutter/material.dart';
import '../data/products.dart';
import '../state/app_state.dart';
import '../ui.dart';

class AdminScreen extends StatelessWidget {
  final AppState state;
  const AdminScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin — Stock")),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        itemCount: kProducts.length,
        itemBuilder: (_, i) {
          final p = kProducts[i];
          final on = state.inStock(p.id);
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
                  "assets/images/item-${p.id}.jpg",
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(p.name,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: on ? kInk : kMuted)),
              subtitle: Text(on ? "Dastiyab" : "Khatam",
                  style: TextStyle(
                      fontSize: 12,
                      color: on ? kGreenDark : Colors.red)),
              trailing: Switch(
                value: on,
                activeThumbColor: kGreen,
                onChanged: (v) => state.setStock(p.id, v),
              ),
            ),
          );
        },
      ),
    );
  }
}
