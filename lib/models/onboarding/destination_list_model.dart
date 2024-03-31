class DestinationListModel {
  bool success;
  int code;
  String msg;
  DestinationListData data;

  DestinationListModel({
    required this.success,
    required this.code,
    required this.msg,
    required this.data,
  });

  factory DestinationListModel.fromJson(Map<String, dynamic> json) {
    return DestinationListModel(
      success: json['success'] ?? false,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? "",
      data: DestinationListData.fromJson(json['data'] ?? {}),
    );
  }
}

class DestinationListData {
  List<Destination> destinations;

  DestinationListData({required this.destinations});

  factory DestinationListData.fromJson(Map<String, dynamic> json) {
    var destinationsJson = json['destinations'] as List? ?? [];
    List<Destination> destinations = destinationsJson.map((destinationJson) => Destination.fromJson(destinationJson)).toList();
    return DestinationListData(destinations: destinations);
  }
}

class Destination {
  String destination;
  String? detail; // detail이 null일 수 있으므로 nullable 타입으로 선언
  String image;

  Destination({
    required this.destination,
    this.detail, // detail은 필수가 아니므로 required 제거
    required this.image,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      destination: json['destination'] ?? "",
      detail: json['detail'], // null일 수 있으므로 기본값을 제공하지 않음
      image: json['image'] ?? "",
    );
  }
}
