import 'dart:convert';

import '../models/home/home_screen_model.dart';
import '../models/home/mate_code_screen_model.dart';
import '../models/home/travel_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class HomeRepository {
  Future<HomeScreenModel> getHomeScreenData() async {
    try {
      dynamic response =
          await NetworkManager.instance.get(ApiUrl.home);
      return HomeScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<MateCodeScreenModel> getMateCode() async {
    try {
      dynamic response =
          await NetworkManager.instance.get(ApiUrl.mateCode);
      return MateCodeScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}
