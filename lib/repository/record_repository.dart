import 'dart:convert';

import '../models/record/record_read_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class RecordRepository {
  Future<RecordReadModel> getRecordView(
      Map<String, String> queryParams) async {
    try {
      String response = await NetworkManager.instance
          .postQuery(ApiUrl.recordView, queryParams);

      return RecordReadModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}

