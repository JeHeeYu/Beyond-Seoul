import 'dart:convert';

import '../models/home/home_screen_model.dart';
import '../models/home/travel_model.dart';
import '../network/network_manager.dart';

class HomeRepository {
  Future<HomeScreenModel> getTravel() async {
    try {
      dynamic response =
          await NetworkManager.instance.get("http://10.0.2.2:8080/get/home");
      return HomeScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}
