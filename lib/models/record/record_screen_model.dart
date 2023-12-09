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
      data: json['data'] != null ? RecordScreenModelData.fromJson(json['data']) : RecordScreenModelData(travels: []),
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
      travels: List<TravelModel>.from(json['travels'] ?? []),
    );
  }
}