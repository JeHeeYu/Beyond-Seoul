class RecordCreateModel {
  final bool success;
  final int code;
  final String msg;

  RecordCreateModel({
    required this.success,
    required this.code,
    required this.msg,
  });

  factory RecordCreateModel.fromJson(Map<String, dynamic> json) {
    return RecordCreateModel(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
    );
  }
}