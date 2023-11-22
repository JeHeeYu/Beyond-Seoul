class Profile {
  String userName;
  String userImage;

  Profile({
    required this.userName,
    required this.userImage,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      userName: json['userName'] ?? "",
      userImage: json['userImage'] ?? "",
    );
  }
}