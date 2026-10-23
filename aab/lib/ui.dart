// Shared theme + tiny widgets for Sabzi Fresh.
import 'package:flutter/material.dart';

const kBg = Color(0xFFF5F5F5);
const kCard = Colors.white;
const kGreen = Color(0xFF51AA1A);
const kGreenDark = Color(0xFF387612);
const kBlue = Color(0xFF1976D2);
const kInk = Color(0xFF1F2A22);
const kMuted = Color(0xFF6E7A70);
const kLine = Color(0xFFE3E3E3);
const kSage = Color(0xFFF2FEF2);

/// Shared soft card shadow (VIP polish).
const kCardShadows = [
  BoxShadow(
      color: Color(0x14000000), blurRadius: 14, offset: Offset(0, 4)),
  BoxShadow(
      color: Color(0x0A387612), blurRadius: 24, offset: Offset(0, 8)),
];

ThemeData sabziTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: "Sora",
    scaffoldBackgroundColor: kBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kGreen,
      primary: kGreenDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
          color: kInk, fontSize: 20, fontWeight: FontWeight.w700),
      iconTheme: IconThemeData(color: kInk),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: kInk),
    ),
  );
}

/// "Rate: ??" — shown everywhere a price would be. Never a real price.
class RateText extends StatelessWidget {
  final double size;
  const RateText({super.key, this.size = 15});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
            color: kInk, fontSize: size, fontWeight: FontWeight.w600),
        children: [
          const TextSpan(text: "Rate: "),
          TextSpan(
            text: "??",
            style: TextStyle(
                color: kGreenDark,
                fontSize: size + 3,
                fontWeight: FontWeight.w800,
                letterSpacing: 2),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Row(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 19, fontWeight: FontWeight.w800, color: kInk)),
        ],
      ),
    );
  }
}
