class RecordReadModel {
  final bool success;
  final int code;
  final String msg;
  final RecordReadData data;

  RecordReadModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory RecordReadModel.fromJson(Map<String, dynamic> json) {
    return RecordReadModel(
      success: json['success'],
      code: json['code'],
      msg: json['msg'],
      data: RecordReadData.fromJson(json['data']),
    );
  }
}

class RecordReadData {
  final int totalElements;
  final int nextCursor;
  final bool isLast;
  final List<RecordContent> content;

  RecordReadData({
    this.totalElements = 0,
    this.nextCursor = -1,
    this.isLast = true,
    this.content = const [],
  });

  factory RecordReadData.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List<dynamic>? ?? [];
    List<RecordContent> content = contentList.map((e) => RecordContent.fromJson(e)).toList();
    return RecordReadData(
      totalElements: json['totalElements'] ?? 0,
      nextCursor: json['nextCursor'] ?? -1,
      isLast: json['isLast'] ?? true,
      content: content,
    );
  }
}

class RecordContent {
  final String image;
  final String uploadAt;
  final String comment;
  final String missionType;
  final String missionTitle;

  RecordContent({
    required this.image,
    required this.uploadAt,
    required this.comment,
    required this.missionType,
    required this.missionTitle,
  });

  factory RecordContent.fromJson(Map<String, dynamic> json) {
    return RecordContent(
      image: json['image'],
      uploadAt: json['uploadAt'],
      comment: json['comment'],
      missionType: json['missionType'],
      missionTitle: json['missionTitle'],
    );
  }
}
