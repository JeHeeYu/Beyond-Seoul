class MissionDetailModel {
  bool success;
  int code;
  String msg;
  MissionDetailData data;

  MissionDetailModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory MissionDetailModel.fromJson(Map<String, dynamic> json) {
    return MissionDetailModel(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
      data: MissionDetailData.fromJson(json['data']),
    );
  }
}

class MissionDetailData {
  String title;
  String? detail;
  String? location;
  double lat;
  double lon;

  MissionDetailData({
    required this.title,
    this.detail,
    this.location,
    required this.lat,
    required this.lon,
  });

  factory MissionDetailData.fromJson(Map<String, dynamic> json) {
    return MissionDetailData(
      title: json['title'],
      detail: json['detail'],
      location: json['location'],
      lat: json['lat'],
      lon: json['lon'],
    );
  }
}
