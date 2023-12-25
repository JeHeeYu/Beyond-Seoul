import 'package:dio/dio.dart';
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

  Future<dynamic> get(String serverUrl) async {
    dynamic responseJson;

    try {
      final response = await http.get(Uri.parse(serverUrl));
      responseJson = returnResponse(response);

      responseJson = utf8.decode(response.bodyBytes);

      //print("responseJson : ${responseJson.toString()}");

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }

  Future<dynamic> post(String serverUrl, Map<String, dynamic> userData) async {
    try {
      String jsonData = jsonEncode(userData);

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: commonHeaders,
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print("POST 성공: ${response.body}");
      } else {
        print("POST 실패: ${response.statusCode}");
      }

      return response;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }

  Future<dynamic> postQuery(String serverUrl, Map<String, dynamic> userData,
      Map<String, dynamic> queryParams) async {
    String queryString = Uri(queryParameters: queryParams).query;
    String urlWithQuery = '$serverUrl?$queryString';

    String jsonData = jsonEncode(userData);

    try {
      final response = await http.post(
        Uri.parse(urlWithQuery),
        headers: commonHeaders,
        body: jsonData,
      );

      Map<String, dynamic> responseData = jsonDecode(response.body);

      return responseData['code'];
    } catch (error) {
      print("에러 발생: $error");
      throw error;
    }
  }

  Future<dynamic> imagePost(String serverUrl, dynamic input) async {
    var dio = Dio();
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      dio.options.headers = commonHeaders;
      var response = await dio.post(
        serverUrl,
        data: input,
      );
      print('Data : ${response.data}');
      return response.data;
    } catch (e) {
      print('Error in imagePost: $e');
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      default:
        return response.body;
    }
  }
}
