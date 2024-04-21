class RecordViewModel {
  final bool success;
  final int code;
  final String msg;
  final RecordViewData data;

  RecordViewModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory RecordViewModel.fromJson(Map<String, dynamic> json) {
    return RecordViewModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? RecordViewData.fromJson(json['data']) : RecordViewData(),
    );
  }
}

class RecordViewData {
  final int totalElements;
  final int nextCursor;
  final bool isLast;
  final List<dynamic> content;

  RecordViewData({
    this.totalElements = 0,
    this.nextCursor = -1,
    this.isLast = true,
    this.content = const [],
  });

  factory RecordViewData.fromJson(Map<String, dynamic> json) {
    return RecordViewData(
      totalElements: json['totalElements'] ?? 0,
      nextCursor: json['nextCursor'] ?? -1,
      isLast: json['isLast'] ?? true,
      content: json['content'] ?? [],
    );
  }
}
