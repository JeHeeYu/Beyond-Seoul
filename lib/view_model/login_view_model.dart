import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/login/login_screen_model.dart';
import '../network/api_response.dart';
import '../repository/login_repository.dart';

class LoginViewModel with ChangeNotifier {
  final _loginRepository = LoginRepository();

  ApiResponse<LoginScreenModel> loginData = ApiResponse.loading();

  String _uid = "";

  String get getUid => _uid;

  void setLoginData(ApiResponse<LoginScreenModel> response) {
    loginData = response;
  }

  void setUid(String id) {
    _uid = id;

    notifyListeners();
  }

  Future<void> login(Map<String, dynamic> data, Uint8List profileImage) async {
    await _loginRepository.login(data, profileImage).then((value) {
      if (value.code != 0) {
        setLoginData(
            ApiResponse.error("Error: Unexpected response code ${value.code}"));
      } else {
        setLoginData(ApiResponse.complete(value));
      }
    }).onError((error, stackTrace) {
      setLoginData(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }
}
