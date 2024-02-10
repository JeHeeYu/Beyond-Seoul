import 'dart:convert';

import 'package:beyond_seoul/models/onboarding/thema_model.dart';

class OnboardingScreenModel {
  bool success;
  int code;
  String msg;
  OnboardingScreenModelData data;

  OnboardingScreenModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory OnboardingScreenModel.fromJson(Map<String, dynamic> json) {
    return OnboardingScreenModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? "",
      data: OnboardingScreenModelData.fromJson(json['data'] ?? {}),
    );
  }
}

class OnboardingScreenModelData {
  List<Thema> themes;
  List<Thema> destinations;

  OnboardingScreenModelData({
    required this.themes,
    required this.destinations,
  });

  factory OnboardingScreenModelData.fromJson(Map<String, dynamic> json) {
    final themeList = json['themes'] as List<dynamic>;
    List<Thema> themes =
        themeList.map((theme) => Thema.fromJson(theme)).toList();

    final destinationsList = json['destinations'] as List<dynamic>;
    List<Thema> destinations =
        destinationsList.map((destination) => Thema.fromJson(destination)).toList();

    return OnboardingScreenModelData(
      themes: themes,
      destinations: destinations,
    );
  }
}
