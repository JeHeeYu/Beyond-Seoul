class Thema {
  String themeName;
  int themeId;
  String image;

  Thema({
    required this.themeName,
    required this.themeId,
    required this.image,
  });

  factory Thema.fromJson(Map<String, dynamic> json) {
    return Thema(
      themeName: json['themeName'] ?? "",
      themeId: json['themeId'] ?? 0,
      image: json['image'] ?? "",
    );
  }
}