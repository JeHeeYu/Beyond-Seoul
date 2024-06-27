
class OnboardingCompleteModel {
  bool success;
  int code;
  String msg;

  OnboardingCompleteModel({
    required this.success,
    required this.code,
    required this.msg,
  });

  factory OnboardingCompleteModel.fromJson(Map<String, dynamic> json) {
    return OnboardingCompleteModel(
      success: json['success'] ?? '',
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }
}

