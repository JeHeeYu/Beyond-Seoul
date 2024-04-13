class OngoingMission {
  int foodMissionId;
  String foodMission;
  int tourMissionId;
  String tourMission;
  int sosoMissionId;
  String sosoMission;

  OngoingMission({
    required this.foodMissionId,
    required this.foodMission,
    required this.tourMissionId,
    required this.tourMission,
    required this.sosoMissionId,
    required this.sosoMission,
  });

  factory OngoingMission.fromJson(Map<String, dynamic> json) {
    return OngoingMission(
      foodMissionId: json['foodMissionId'] ?? 0,
      foodMission: json['foodMission'] ?? "",
      tourMissionId: json['tourMissionId'] ?? 0,
      tourMission: json['tourMission'] ?? "",
      sosoMissionId: json['sosoMissionId'] ?? 0,
      sosoMission: json['sosoMission'] ?? "",
    );
  }
}
