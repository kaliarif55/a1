class Word {
  final String de;
  final String tr;

  Word({required this.de, required this.tr});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
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
