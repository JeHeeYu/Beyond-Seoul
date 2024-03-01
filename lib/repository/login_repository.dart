import 'dart:convert';

import '../models/login/login_screen_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class LoginRepository {
  Future<LoginScreenModel> login(Map<String, dynamic> data) async {
    try {
      dynamic response = await NetworkManager.instance.post(ApiUrl.login, data);
      return LoginScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}
