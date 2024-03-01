import 'package:flutter/material.dart';

import '../models/login/login_screen_model.dart';
import '../network/api_response.dart';
import '../repository/login_repository.dart';

class LoginViewModel with ChangeNotifier {
  final _loginRepository = LoginRepository();

  ApiResponse<LoginScreenModel> loginData = ApiResponse.loading();

  void setLoginData(ApiResponse<LoginScreenModel> response) {
    loginData = response;
  }

  Future<void> login(Map<String, dynamic> data) async {
    await _loginRepository.login(data).then((value) {
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
