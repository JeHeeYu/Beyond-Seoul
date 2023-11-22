class TravelData {
  bool success;
  int code;
  String msg;
  TravelInfo data;

  TravelData({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory TravelData.fromJson(Map<String, dynamic> json) {
    return TravelData(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
      data: TravelInfo.fromJson(json['data']),
    );
  }
}

class TravelInfo {
  String userName;
  String userImage;
  String travelName;
  String travelDate;
  int travelId;
  List<String> travelFreinds;
  List<Reservation>? reservations;
  MissionComplete? missionComplete;
  TeamMission? teamMission;
  PersonMission? personMission;
  String? dailyMissionCount;
  List<DailyMission>? dailyMissions;

  TravelInfo({
    required this.userName,
    required this.userImage,
    required this.travelName,
    required this.travelDate,
    required this.travelId,
    required this.travelFreinds,
    required this.reservations,
    required this.missionComplete,
    required this.teamMission,
    required this.personMission,
    required this.dailyMissionCount,
    required this.dailyMissions,
  });

  factory TravelInfo.fromJson(Map<String, dynamic> json) {
    return TravelInfo(
      userName: json['profile']['userName'] ?? "",
      userImage: json['profile']['userImage'] ?? "",
      travelName: json['travel']['travelName'] ?? "",
      travelDate: json['travel']['travelDate'] ?? "",
      travelId: json['travel']['travelId'] ?? 0,
      travelFreinds: List<String>.from(json['travel']['travelFreinds'] ?? []),
      reservations: json['reservations'] != null
          ? List<Reservation>.from(
              json['reservations'].map((x) => Reservation.fromJson(x)),
            )
          : null,
      missionComplete: json['mission']['missionComplete'] != null
          ? MissionComplete.fromJson(json['mission']['missionComplete'])
          : null,
      teamMission: json['mission']['teamMission'] != null
          ? TeamMission.fromJson(json['mission']['teamMission'])
          : null,
      personMission: json['mission']['personMission'] != null
          ? PersonMission.fromJson(json['mission']['personMission'])
          : null,
      dailyMissionCount: json['mission']['dailyMissionCount'],
      dailyMissions: json['mission']['dailyMissions'] != null
          ? List<DailyMission>.from(
              json['mission']['dailyMissions'].map(
                (x) => DailyMission.fromJson(x),
              ),
            )
          : null,
    );
  }
}

class Reservation {
  String destination;
  String date;
  String time;

  Reservation({
    required this.destination,
    required this.date,
    required this.time,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      destination: json['destination'],
      date: json['date'],
      time: json['time'],
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