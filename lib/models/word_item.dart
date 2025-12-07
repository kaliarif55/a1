class WordItem {
  final String de;
  final String tr;

  WordItem({required this.de, required this.tr});

  factory WordItem.fromJson(Map<String, dynamic> json) {
    return WordItem(
      de: json['de'] as String,
      tr: json['tr'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'de': de,
      'tr': tr,
    };
  }
}
