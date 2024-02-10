class Destination {
  String destination;
  String detail;
  String image;

  Destination({
    required this.destination,
    required this.detail,
    required this.image,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      destination: json['destination'] ?? "",
      detail: json['detail'] ?? "",
      image: json['image'] ?? "",
    );
  }
}