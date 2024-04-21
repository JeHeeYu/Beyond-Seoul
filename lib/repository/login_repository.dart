import 'dart:convert';
import 'dart:typed_data';

import '../models/login/login_screen_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class LoginRepository {
  Future<LoginScreenModel> login(Map<String, dynamic> data, Uint8List profileImage) async {
    try {
      dynamic response = await NetworkManager.instance.imagePost(ApiUrl.login, data, profileImage);
      return LoginScreenModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
