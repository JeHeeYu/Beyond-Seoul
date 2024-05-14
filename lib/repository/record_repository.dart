import 'dart:convert';
import 'dart:typed_data';

import '../models/record/record_create_model.dart';
import '../models/record/record_read_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class RecordRepository {
  Future<RecordReadModel> getRecordView(Map<String, String> queryParams) async {
    try {
      String response = await NetworkManager.instance
          .postQuery(ApiUrl.recordView, queryParams);

      return RecordReadModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<RecordCreateModel> createRecord(
      Map<String, String> data, Uint8List? imageBytes) async {
    try {
      String response = await NetworkManager.instance
          .postInImage(ApiUrl.recordCreate, data, imageBytes);
      return RecordCreateModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}
