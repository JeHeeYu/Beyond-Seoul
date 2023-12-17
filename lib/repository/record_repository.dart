import 'dart:convert';

import '../models/record/record_screen_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class RecordRepository {
  Future<RecordScreenModel> getRecordScreenData() async {
    try {
      dynamic response = await NetworkManager.instance.post(ApiUrl.recordCreate, {});
      
      String responseBody = response.body;

      // dynamic response =
      //     await NetworkManager.instance.get(ApiUrl.home);
      // return HomeScreenModel.fromJson(jsonDecode(response));
      
      return RecordScreenModel.fromJson(jsonDecode(responseBody));
    } catch (e) {
      rethrow;
    }
  }
}
