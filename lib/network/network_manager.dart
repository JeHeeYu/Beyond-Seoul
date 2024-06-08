import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import '../statics/images.dart';
import 'api_response.dart';

import 'package:flutter/services.dart' show rootBundle;

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
      String serverUrl, Map<String, dynamic> queryParams) async {
    dynamic responseJson;
    try {
      Map<String, String> stringParams =
          queryParams.map((key, value) => MapEntry(key, value.toString()));

      String queryString = Uri(queryParameters: stringParams).query;
      String urlWithQuery = '$serverUrl?$queryString';

      final response =
          await http.get(Uri.parse(urlWithQuery), headers: commonHeaders);
      responseJson = utf8.decode(response.bodyBytes);
      print("GET Query 성공: ${responseJson}");
      return responseJson;
    } catch (error) {
      print("에러 발생 123: $error");
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
        print("POST 실패: ${response.body},   ${responseJson} ${response}");
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

  Future<dynamic> imagePost(String serverUrl, Map<String, dynamic> data) async {
    var dio = Dio();
    FormData formData;

    try {
      ByteData byteData = await rootBundle.load(Images.profileDisable);
      List<int> imageBytes = byteData.buffer.asUint8List();

      formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(
          imageBytes,
          filename: "image.png",
          contentType: MediaType("image", "png"),
        ),
        "idToken": data["idToken"],
        "email": data["email"],
        "name": data["name"],
        "sns": data["sns"],
      });

      formData.fields.forEach((field) {
        print("Field: ${field.key} = ${field.value}");
      });
      formData.files.forEach((file) {
        print(
            "File: ${file.key} = ${file.value.filename}, ${file.value.contentType}");
      });
    } catch (error) {
      print("에러: $error");
      return null;
    }

    try {
      var response = await dio.post(
        serverUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          },
        ),
      );

      print("성공: ${response.data}");
      return response.data;
    } catch (error) {
      print(" 에러 발생: $error, FormData: ${formData.fields}, ${formData.files}");
      return null;
    }
  }

  Future<dynamic> imagePut(String serverUrl, Map<String, dynamic> data) async {
    var dio = Dio();
    FormData formData;

    try {
      ByteData byteData = await rootBundle.load(Images.profileDisable);
      List<int> imageBytes = byteData.buffer.asUint8List();

      formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(
          imageBytes,
          filename: "image.png",
          contentType: MediaType("image", "png"),
        ),
        "uid": data["uid"],
        "sex": data["sex"],
        "nickname": data["nickname"],
        "birth": data["birth"],
      });

      formData.fields.forEach((field) {
        print("Field: ${field.key} = ${field.value}");
      });
      formData.files.forEach((file) {
        print(
            "File: ${file.key} = ${file.value.filename}, ${file.value.contentType}");
      });
    } catch (error) {
      print("에러: $error");
      return null;
    }

    try {
      var response = await dio.put(
        serverUrl,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Accept": "application/json",
          },
        ),
      );

      print("성공: ${response.data}");
      return response.data;
    } catch (error) {
      print(" 에러 발생: $error, FormData: ${formData.fields}, ${formData.files}");
      return null;
    }
  }

  Future<dynamic> postInImage(String serverUrl, Map<String, dynamic> data,
      Uint8List? imageBytes) async {
    var uri = Uri.parse(serverUrl);
    var request = http.MultipartRequest('POST', uri);

    data.forEach((key, value) {
      request.fields[key] = value.toString();
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
        String responseBody = await response.stream.bytesToString();
        print('서버 에러 발생. 상태 코드: ${response.statusCode}');
        print('서버 응답: $responseBody');
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
