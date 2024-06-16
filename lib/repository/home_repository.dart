import 'dart:convert';

import '../models/home/home_screen_model.dart';
import '../models/home/mate_code_screen_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class HomeRepository {
  Future<HomeScreenModel> getHomeScreenData(Map<String, String> queryParams) async {
    try {
      dynamic response =
          await NetworkManager.instance.getQuery(ApiUrl.home, queryParams);
      return HomeScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<MateCodeScreenModel> getMateCode(Map<String, String> queryParams) async {
    try {
      dynamic response =
          await NetworkManager.instance.getQuery(ApiUrl.mateCode, queryParams);
      return MateCodeScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}
