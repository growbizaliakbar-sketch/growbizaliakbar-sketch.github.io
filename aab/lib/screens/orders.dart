// Orders tab: local history of WhatsApp orders sent from this phone.
import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../ui.dart';

class OrdersScreen extends StatelessWidget {
  final AppState state;
  const OrdersScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text("Mere Orders",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800)),
          ),
          Expanded(
            child: state.orders.isEmpty
                ? const Center(
                    child: Text("Abhi tak koi order nahi bheja.",
                        style:
                            TextStyle(fontSize: 16, color: kMuted)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: state.orders.length,
                    itemBuilder: (_, i) {
                      final o = state.orders[i];
                      final lines =
                          (o['lines'] as List).cast<String>();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: kLine),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            fmtOrderDate(o['ts'] as int),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            "${lines.length} cheezein • Ilaqa: ${o['area']}",
                            style: const TextStyle(
                                fontSize: 12, color: kMuted),
                          ),
                          children: lines
                              .map((l) => ListTile(
                                    dense: true,
                                    title: Text(l,
                                        style: const TextStyle(
                                            fontSize: 14)),
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
