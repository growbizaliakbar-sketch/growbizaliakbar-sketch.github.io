// Sabzi Fresh — product catalog (hardcoded, no backend)
class Product {
  final String id;
  final String name; // "English - اردو" display name
  final String roman; // roman-urdu search keyword
  final String unit; // 'kg' or 'gaddi'
  final String note;
  final String about;
  const Product(
      {required this.id,
      required this.name,
      required this.roman,
      required this.unit,
      required this.note,
      required this.about});
}

const List<Product> kProducts = [
  Product(
      id: "tamatar",
      name: "Tomato - ٹماٹر",
      roman: "tamatar",
      unit: "kg",
      note: "Laal, sakht aur ras bhare",
      about:
          "Lal ras bhare taaza tamatar — salan aur salad dono ke liye behtareen."),
  Product(
      id: "pyaaz",
      name: "Onion - پیاز",
      roman: "pyaaz",
      unit: "kg",
      note: "Meethi, gulabi pyaaz",
      about: "Meethi gulabi pyaaz — har khane ki bunyaad."),
  Product(
      id: "aloo",
      name: "Potato - آلو",
      roman: "aloo",
      unit: "kg",
      note: "Har handi ka sathi",
      about: "Sakht aur taaza aloo — har handi ka sathi."),
  Product(
      id: "shimla",
      name: "Capsicum - شملہ مرچ",
      roman: "shimla mirch",
      unit: "kg",
      note: "Hari, moti aur chamakdar",
      about: "Hari moti shimla mirch — khane mein rang aur zaika."),
  Product(
      id: "bandgobhi",
      name: "Cabbage - بند گوبھی",
      roman: "band gobhi",
      unit: "kg",
      note: "Sakht phool, taaza pattay",
      about:
          "Sakht phool wali taaza band gobhi — salan aur salad ke liye."),
  Product(
      id: "bhindi",
      name: "Okra - بھنڈی",
      roman: "bhindi",
      unit: "kg",
      note: "Naram, komal phalian",
      about: "Naram komal bhindi — taazi ho to lazeez banti hai."),
  Product(
      id: "palak",
      name: "Spinach - پالک",
      roman: "palak",
      unit: "gaddi",
      note: "Hari bhari gaddi",
      about: "Hari bhari taaza palak — sehat se bharpur."),
  Product(
      id: "kheera",
      name: "Cucumber - کھیرا",
      roman: "kheera",
      unit: "kg",
      note: "Thanda, kurkura kheera",
      about: "Thande kurkure kheere — garmi mein rahat."),
  Product(
      id: "gajar",
      name: "Carrot - گاجر",
      roman: "gajar",
      unit: "kg",
      note: "Meethi laal gajar",
      about: "Meethi laal gajar — halwa ho ya salad, sab mein kamal."),
  Product(
      id: "harimirch",
      name: "Green Chili - ہری مرچ",
      roman: "hari mirch",
      unit: "kg",
      note: "Teekhi hari mirch",
      about: "Teekhi hari mirch — chatpata zaika har khane mein."),
  Product(
      id: "loki",
      name: "Bottle Gourd - لوکی",
      roman: "loki",
      unit: "kg",
      note: "Naram, halki loki",
      about: "Naram halki loki — halka phulka sehatmand salan."),
  Product(
      id: "karelay",
      name: "Bitter Gourd - کریلے",
      roman: "karelay",
      unit: "kg",
      note: "Taaza hare karelay",
      about: "Taaze hare karelay — karwahat mein chhupa faida."),
  Product(
      id: "semphali",
      name: "Beans - سیم پھلی",
      roman: "sem phali",
      unit: "kg",
      note: "Komal hari phali",
      about: "Komal hari sem phali — naram aur lazeez."),
  Product(
      id: "mooli",
      name: "Radish - مولی",
      roman: "mooli",
      unit: "kg",
      note: "Safed, ras bhari mooli",
      about: "Safed ras bhari mooli — salad aur parathon ki shaan."),
  Product(
      id: "tori",
      name: "Ridge Gourd - توری",
      roman: "tori",
      unit: "kg",
      note: "Naram hari tori",
      about: "Naram hari tori — halka aur lazeez salan."),
  Product(
      id: "dhaniya",
      name: "Coriander - دھنیا",
      roman: "dhaniya",
      unit: "gaddi",
      note: "Khushbudar hari dhaniya",
      about: "Khushbudar hari dhaniya — har khane ki zeenat."),
  Product(
      id: "matar",
      name: "Peas - مٹر",
      roman: "matar",
      unit: "kg",
      note: "Hare bhare taaza matar",
      about:
          "Hare bhare meethay matar — pulao aur salan dono mein behtareen."),
];

Product productById(String id) => kProducts.firstWhere((p) => p.id == id);

// Category id -> label + product ids
const Map<String, String> kCategoryLabels = {
  "sab": "Sab",
  "hari": "Hari Sabzi",
  "salad": "Salad",
};

const Map<String, List<String>> kCategories = {
  "sab": [
    "tamatar",
    "pyaaz",
    "aloo",
    "shimla",
    "bandgobhi",
    "bhindi",
    "palak",
    "kheera",
    "gajar",
    "harimirch",
    "loki",
    "karelay",
    "semphali",
    "mooli",
    "tori",
    "dhaniya",
    "matar"
  ],
  "hari": [
    "palak",
    "dhaniya",
    "shimla",
    "harimirch",
    "bhindi",
    "karelay",
    "tori",
    "semphali",
    "kheera",
    "matar"
  ],
  "salad": ["tamatar", "kheera", "pyaaz", "mooli", "gajar"],
};

String fmtWazan(double w, String unit) {
  final wStr = (w == w.truncateToDouble()) ? w.toInt().toString() : w.toString();
  return "$wStr $unit";
}

// WhatsApp number (0343) — 0305 is CALL ONLY and must never appear in a wa.me link.
const String kWaNumber = "923437313039";
const String kCallNumber = "03055436385";
