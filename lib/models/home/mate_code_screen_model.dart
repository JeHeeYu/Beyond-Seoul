class MateCodeScreenModel {
  bool success;
  int code;
  String msg;
  MateCodeScreenModelData data;

  MateCodeScreenModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory MateCodeScreenModel.fromJson(Map<String, dynamic> json) {
    return MateCodeScreenModel(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
      data: MateCodeScreenModelData.fromJson(json['data']),
    );
  }
}

class MateCodeScreenModelData {
  String expiredTime;
  String code;

  MateCodeScreenModelData({
    required this.expiredTime,
    required this.code,
  });

  factory MateCodeScreenModelData.fromJson(Map<String, dynamic> json) {
    String expiredTimeStr = json['expiredTime']?.toString() ?? "";
    return MateCodeScreenModelData(
      expiredTime: expiredTimeStr,
      code: json['code'] ?? "",
    );
  }
}
