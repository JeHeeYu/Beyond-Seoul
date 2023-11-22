class Travel {
  int travelId;
  List<String> travelFreinds;

  Travel({
    required this.travelId,
    required this.travelFreinds,
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      travelId: json['travelId'] ?? 0,
      travelFreinds: List<String>.from(json['travelFreinds'] ?? []),
    );
  }
}