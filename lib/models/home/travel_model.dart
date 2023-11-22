class Travel {
  int travelId;
  String travelName;
  String travelDate;
  List<String> travelFreinds;

  Travel({
    required this.travelId,
    required this.travelName,
    required this.travelDate,
    required this.travelFreinds,
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      travelId: json['travelId'] ?? 0,
      travelName: json['travelName'] ?? "",
      travelDate: json['travelDate'] ?? "",
      travelFreinds: List<String>.from(json['travelFreinds'] ?? []),
    );
  }
}