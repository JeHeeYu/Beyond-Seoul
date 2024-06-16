class TravelNameModel {
  final bool success;
  final int code;
  final String msg;
  final List<TravelData> data;

  TravelNameModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory TravelNameModel.fromJson(Map<String, dynamic> json) {
    return TravelNameModel(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
      data: (json['data'] as List).map((i) => TravelData.fromJson(i)).toList(),
    );
  }
}

class TravelData {
  final String title;
  final int id;

  TravelData({
    required this.title,
    required this.id,
  });

  factory TravelData.fromJson(Map<String, dynamic> json) {
    return TravelData(
      title: json['title'],
      id: json['id'],
    );
  }
}
