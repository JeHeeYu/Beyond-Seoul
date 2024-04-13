class MissionCount {
  int foodMissionCount;
  int tourMissionCount;
  int sosoMissionCount;

  MissionCount({
    required this.foodMissionCount,
    required this.tourMissionCount,
    required this.sosoMissionCount,
  });

  factory MissionCount.fromJson(Map<String, dynamic> json) {
    return MissionCount(
      foodMissionCount: json['foodMissionCount'] ?? 0,
      tourMissionCount: json['tourMissionCount'] ?? 0,
      sosoMissionCount: json['sosoMissionCount'] ?? 0,
    );
  }
}
