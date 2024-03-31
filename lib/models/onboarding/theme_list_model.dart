class ThemeListModel {
  bool success;
  int code;
  String msg;
  ThemeListData data;

  ThemeListModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory ThemeListModel.fromJson(Map<String, dynamic> json) {
    return ThemeListModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? "",
      data: ThemeListData.fromJson(json['data'] ?? {}),
    );
  }
}

class ThemeListData {
  List<Theme> themes;

  ThemeListData({required this.themes});

  factory ThemeListData.fromJson(Map<String, dynamic> json) {
    var themesJson = json['themes'] as List? ?? [];
    List<Theme> themes = themesJson.map((themeJson) => Theme.fromJson(themeJson)).toList();
    return ThemeListData(themes: themes);
  }
}

class Theme {
  String themeName;
  int themeId;
  String image;

  Theme({
    required this.themeName,
    required this.themeId,
    required this.image,
  });

  factory Theme.fromJson(Map<String, dynamic> json) {
    return Theme(
      themeName: json['themeName'] ?? "",
      themeId: json['themeId'] ?? 0,
      image: json['image'] ?? "",
    );
  }
}
