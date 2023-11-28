import 'package:beyond_seoul/models/home/profile_model.dart';
import 'package:beyond_seoul/models/home/travel_model.dart';

import 'mission_model.dart';

class HomeScreenModel {
  bool success;
  int code;
  String msg;
  HomeScreenModelData data;

  HomeScreenModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
      data: HomeScreenModelData.fromJson(json['data']),
    );
  }
}

class HomeScreenModelData {
  Profile profile;
  Mission mission;
  String travelStatus;
  Travel travel;

  HomeScreenModelData({
    required this.profile,
    required this.mission,
    required this.travelStatus,
    required this.travel,
  });

  factory HomeScreenModelData.fromJson(Map<String, dynamic> json) {
    return HomeScreenModelData(
      profile: Profile.fromJson(json['profile'] ?? {}),
      mission: Mission.fromJson(json['mission'] ?? {}),
      travelStatus: json['travelStatus'] ?? '',
      travel: Travel.fromJson(json['travel'] ?? {}),
    );
  }
}
