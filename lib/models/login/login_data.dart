class LoginData {
  String? id;
  String email;
  String sex;
  String nickName;
  String? birth;
  String image;
  String status;
  String createDate;
  String registerYN;

  LoginData({
    this.id,
    required this.email,
    required this.sex,
    required this.nickName,
    this.birth,
    required this.image,
    required this.status,
    required this.createDate,
    required this.registerYN,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      id: json['id'],
      email: json['email'],
      sex: json['sex'],
      nickName: json['nickName'],
      birth: json['birth'],
      image: json['image'],
      status: json['status'],
      createDate: json['createDate'],
      registerYN: json['registerYN'],
    );
  }
}
