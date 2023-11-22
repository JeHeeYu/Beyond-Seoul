class Mission {
  MissionComplete? missionComplete;
  TeamMission? teamMission;
  PersonMission? personMission;
  String? dailyMissionCount;
  List<DailyMission>? dailyMissions;

  Mission({
    required this.missionComplete,
    required this.teamMission,
    required this.personMission,
    required this.dailyMissionCount,
    required this.dailyMissions,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      missionComplete: json['missionComplete'] != null
          ? MissionComplete.fromJson(json['missionComplete'])
          : null,
      teamMission: json['teamMission'] != null
          ? TeamMission.fromJson(json['teamMission'])
          : null,
      personMission: json['personMission'] != null
          ? PersonMission.fromJson(json['personMission'])
          : null,
      dailyMissionCount: json['dailyMissionCount'],
      dailyMissions: json['dailyMissions'] != null
          ? List<DailyMission>.from(
              json['dailyMissions'].map(
                (x) => DailyMission.fromJson(x),
              ),
            )
          : null,
    );
  }
}

class MissionComplete {
  int team;
  int person;
  int daily;

  MissionComplete({
    required this.team,
    required this.person,
    required this.daily,
  });

  factory MissionComplete.fromJson(Map<String, dynamic> json) {
    return MissionComplete(
      team: json['team'],
      person: json['person'],
      daily: json['daily'],
    );
  }
}

class TeamMission {
  int id;
  String title;
  String? detail;

  TeamMission({
    required this.id,
    required this.title,
    this.detail,
  });

  factory TeamMission.fromJson(Map<String, dynamic> json) {
    return TeamMission(
      id: json['id'],
      title: json['title'],
      detail: json['detail'],
    );
  }
}

class PersonMission {
  int id;
  String title;
  String? detail;

  PersonMission({
    required this.id,
    required this.title,
    this.detail,
  });

  factory PersonMission.fromJson(Map<String, dynamic> json) {
    return PersonMission(
      id: json['id'],
      title: json['title'],
      detail: json['detail'],
    );
  }
}

class DailyMission {
  int id;
  String title;

  DailyMission({
    required this.id,
    required this.title,
  });

  factory DailyMission.fromJson(Map<String, dynamic> json) {
    return DailyMission(
      id: json['id'],
      title: json['title'],
    );
  }
}