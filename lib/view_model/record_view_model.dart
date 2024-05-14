import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/record/record_read_model.dart';
import '../network/api_response.dart';
import '../repository/record_repository.dart';

class RecordViewModel with ChangeNotifier {
  final _recordRepo = RecordRepository();

  ApiResponse<RecordReadModel> recordData = ApiResponse.loading();

  ApiResponse<RecordReadModel> get getRecordData => recordData;

  void setRecordImageList(ApiResponse<RecordReadModel> response) {
    recordData = response;
    notifyListeners();
  }

  Future<void> fetchRecordView(Map<String, String> queryParams) async {
    await _recordRepo.getRecordView(queryParams).then((value) {
      setRecordImageList(ApiResponse.complete(value));
    }).catchError((error, stackTrace) {
      setRecordImageList(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }

  Future<int> createRecord(
      Map<String, String> data, Uint8List? imageBytes) async {
    try {
      final result = await _recordRepo.createRecord(data, imageBytes);
      return result.code;
    } catch (error) {
      return 400;
    }
  }
}
