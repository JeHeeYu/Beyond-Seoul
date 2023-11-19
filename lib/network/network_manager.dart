import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkManager {
  Map<String, String> commonHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  static final NetworkManager _instance = NetworkManager._internal();

  NetworkManager._internal();

  static NetworkManager get instance => _instance;

  Future<String> get(String serverUrl) async {
    print("Get Test");

    try {
      final response = await http.get(
        Uri.parse(serverUrl),
        headers: commonHeaders,
      );

      String responseBody = utf8.decode(response.bodyBytes);

      print("responseBody : ${responseBody}");

      return responseBody;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }

  Future<void> post(String serverUrl, Map<String, dynamic> userData) async {
    print("Jehee Post Test");

    try {
      String jsonData = jsonEncode(userData);

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: commonHeaders,
        body: jsonData,
      );

      print("Jehee : ${response.body}");

      if (response.statusCode == 200) {
        print("POST 성공: ${response.body}");
      } else {
        print("POST 실패: ${response.statusCode}");
      }
    } catch (error) {
      print("에러 발생: $error");
    }
  }
}
