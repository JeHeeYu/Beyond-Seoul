import 'login_data.dart';

class LoginScreenModel {
  bool success;
  int code;
  String msg;
  LoginData data;

  LoginScreenModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory LoginScreenModel.fromJson(Map<String, dynamic> json) {
    return LoginScreenModel(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

