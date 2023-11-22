import 'dart:convert';

import '../models/travel_model.dart';
import '../network/network_manager.dart';

class HomeRepository {
Future<TravelData> getTravel() async {
  try {
    dynamic response = await NetworkManager.instance.get("http://10.0.2.2:8080/get/home");
    return TravelData.fromJson(jsonDecode(response));
  } catch (e) {
    rethrow;
  }
}
}
