import 'package:flutter/material.dart';

import '../models/record/record_screen_model.dart';
import '../network/api_response.dart';
import '../repository/record_repository.dart';

class RecordViewModel with ChangeNotifier {
  final _reocrdRepo = RecordRepository();

  ApiResponse<RecordScreenModel> recordData = ApiResponse.loading();

  void setRecordImageList(ApiResponse<RecordScreenModel> response) {
    recordData = response;
    
    notifyListeners();
  }

  Future<void> fetchRecordImageApi() async {
    await _reocrdRepo.getRecordScreenData().then((value) {
      setRecordImageList(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setRecordImageList(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }
}
