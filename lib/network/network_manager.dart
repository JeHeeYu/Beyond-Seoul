import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'api_response.dart';

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

      print("GET 성공: ${responseJson}");

      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
    }
  }

  Future<dynamic> post(String serverUrl, Map<String, dynamic> userData) async {
    try {
      dynamic responseJson;
      String jsonData = jsonEncode(userData);

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: commonHeaders,
        body: jsonData,
      );

      responseJson = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        print("POST 성공: ${responseJson}");
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

  Future<dynamic> imagePost(String serverUrl, Map<String, dynamic> userData,
      Uint8List? thumbnailData) async {
    Map<String, dynamic> sendData = userData;

    var dio = Dio();

    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromBytes(
        thumbnailData!,
        filename: 'files.png',
        contentType: MediaType('image', 'png'),
      ),
      "dto": MultipartFile.fromString(
        jsonEncode(sendData),
        contentType: MediaType('application', 'json'),
      ),
    });

    try {
      Response response = await dio.post(
        serverUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Image upload successful');
      } else {
        print('Image upload failed with status: ${response.statusCode}');
      }

      return response.data;
    } catch (error) {
      print('Error uploading: $error');
      throw error;
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 0:
      case 200:
        return response.body;
      default:
        return ApiResponse.error;
    }
  }
}
