class RecordModel {
  String image;
  String uploadAt;
  String comment;
  String missionType;
  String missionTitle;

  RecordModel({
    required this.image,
    required this.uploadAt,
    required this.comment,
    required this.missionType,
    required this.missionTitle,
  });

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      image: json['image'] ?? "",
      uploadAt: json['uploadAt'] ?? "",
      comment: json['comment'] ?? "",
      missionType: json['missionType'] ?? "",
      missionTitle: json['missionTitle'] ?? "",
    );
  }
}