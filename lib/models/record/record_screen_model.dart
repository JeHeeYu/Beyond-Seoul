import 'package:beyond_seoul/models/record/travel_model.dart';

class RecordScreenModel {
  bool success;
  int code;
  String msg;
  RecordScreenModelData data;

  RecordScreenModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory RecordScreenModel.fromJson(Map<String, dynamic> json) {
    return RecordScreenModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? "",
      data: RecordScreenModelData.fromJson(json),
    );
  }
}

class RecordScreenModelData {
  List<TravelModel> travels;

  RecordScreenModelData({
    required this.travels,
  });

  factory RecordScreenModelData.fromJson(Map<String, dynamic> json) {
    return RecordScreenModelData(
      travels: (json['travels'] as List<dynamic> ?? []).map(
        (travel) => TravelModel.fromJson(travel),
      ).toList(),
    );
  }
}