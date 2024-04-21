import 'dart:convert';

import '../models/record/record_screen_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class RecordRepository {
    Future<RecordScreenModel> getRecordView(Map<String, String> queryParams) async {
    try {
      dynamic response = await NetworkManager.instance.postQuery(ApiUrl.recordView, queryParams);
      
      String responseBody = response.body;

      print("Jehee : ${responseBody}");
      
      return RecordScreenModel.fromJson(jsonDecode(responseBody));
    } catch (e) {
      rethrow;
    }
  }
}
