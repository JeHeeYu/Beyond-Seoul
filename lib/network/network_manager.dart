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

  Future<dynamic> getQuery(
      String serverUrl, Map<String, String> queryParams) async {
    dynamic responseJson;
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String urlWithQuery = '$serverUrl?$queryString';
      final response =
          await http.get(Uri.parse(urlWithQuery), headers: commonHeaders);
      responseJson = utf8.decode(response.bodyBytes);
      print("GET Query 성공: ${responseJson}");
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

  Future<dynamic> postQuery(
      String serverUrl, Map<String, String> queryParams) async {
    try {
      String queryString = Uri(queryParameters: queryParams).query;
      String urlWithQuery = '$serverUrl?$queryString';

      final response =
          await http.post(Uri.parse(urlWithQuery), headers: commonHeaders);

      dynamic responseJson = utf8.decode(response.bodyBytes);
      print("POST Query 성공: ${responseJson}");
      return responseJson;
    } catch (error) {
      print("에러 발생: $error");
      return "";
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

  Future<dynamic> postInImage(
      String serverUrl, Map<String, String> data, Uint8List? imageBytes) async {
    var uri = Uri.parse(serverUrl);
    var request = http.MultipartRequest('POST', uri);

    data.forEach((key, value) {
      request.fields[key] = value;
    });

    if (imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'upload.png',
        contentType: MediaType('image', 'png'),
      ));
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('서버 응답: $responseBody');
        return responseBody;
      } else {
        print('서버 에러 발생. 상태 코드: ${response.statusCode}');
        return 'Error: Server responded with status code ${response.statusCode}';
      }
    } catch (error) {
      print("에러 발생: $error");
      return 'Error: $error';
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
