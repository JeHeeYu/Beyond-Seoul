class Travel {
  int travelId;
  String travelTitle;
  String travelDate;
  List<String> travelFreinds;

  Travel({
    required this.travelId,
    required this.travelTitle,
    required this.travelDate,
    required this.travelFreinds,
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      travelId: json['travelId'] ?? 0,
      travelTitle: json['travelTitle'] ?? "",
      travelDate: json['travelDate'] ?? "",
      travelFreinds: List<String>.from(json['travelFreinds'] ?? []),
    );
  }
}