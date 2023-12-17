import 'package:beyond_seoul/models/record/records_model.dart';

class TravelModel {
  String title;
  List<RecordModel> records;

  TravelModel({
    required this.title,
    required this.records,
  });

  factory TravelModel.fromJson(Map<String, dynamic> json) {
    return TravelModel(
      title: json['title'] ?? "",
      records: (json['records'] as List<dynamic> ?? []).map(
        (record) => RecordModel.fromJson(record),
      ).toList(),
    );
  }
}