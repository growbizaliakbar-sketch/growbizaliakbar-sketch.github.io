// Sabzi Fresh — Sadam Hussain Sabzi Farosh
// GrocerApp-style vegetable shop app. Roman Urdu. No prices, no login.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'state/app_state.dart';
import 'screens/home.dart';
import 'screens/tokri.dart';
import 'screens/orders.dart';
import 'screens/dukaan.dart';
import 'ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final state = AppState(prefs);
  await state.load();
  runApp(SabziApp(state: state));
}

class SabziApp extends StatelessWidget {
  final AppState state;
  const SabziApp({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sabzi Fresh",
      debugShowCheckedModeBanner: false,
      theme: sabziTheme(),
      home: MainTabs(state: state),
    );
  }
}

class MainTabs extends StatefulWidget {
  final AppState state;
  const MainTabs({super.key, required this.state});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(state: widget.state),
      TokriScreen(state: widget.state),
      OrdersScreen(state: widget.state),
      DukaanScreen(state: widget.state),
    ];
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(index: _index, children: pages),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: kLine)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4)),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) => setState(() => _index = i),
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: kGreenDark,
              unselectedItemColor: kMuted,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              items: [
                const BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: "Home"),
                BottomNavigationBarItem(
                  icon: _TokriIcon(count: widget.state.cartCount),
                  label: "Tokri",
                ),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long_outlined),
                    activeIcon: Icon(Icons.receipt_long),
                    label: "Orders"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.storefront_outlined),
                    activeIcon: Icon(Icons.storefront),
                    label: "Dukaan"),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TokriIcon extends StatelessWidget {
  final int count;
  const _TokriIcon({required this.count});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_basket_outlined),
        if (count > 0)
          Positioned(
            right: -8,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  color: kGreenDark, shape: BoxShape.circle),
              constraints:
                  const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text("$count",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800)),
            ),
          ),
      ],
    );
  }
}
