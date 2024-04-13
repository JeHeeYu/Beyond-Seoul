import 'package:beyond_seoul/models/home/misson_count_model.dart';
import 'package:beyond_seoul/models/home/profile_model.dart';
import 'package:beyond_seoul/models/home/travel_model.dart';

import 'on_going_mission_model.dart';

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
  OngoingMission ongoingMission;
  Travel travel;
  MissionCount missionCount;

  HomeScreenModelData({
    required this.profile,
    required this.ongoingMission, 
    required this.travel,
    required this.missionCount,
  });

  factory HomeScreenModelData.fromJson(Map<String, dynamic> json) {
    return HomeScreenModelData(
      profile: Profile.fromJson(json['profile'] ?? {}),
      travel: Travel.fromJson(json['travel'] ?? {}),
      ongoingMission: OngoingMission.fromJson(json['ongoingMission'] ?? {}),
      missionCount: MissionCount.fromJson(json['missionCount'] ?? {}),
    );
  }
}
