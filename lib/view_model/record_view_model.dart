import 'dart:typed_data';

import 'package:beyond_seoul/models/record/mission_detail_model.dart';
import 'package:flutter/material.dart';

import '../models/record/record_create_model.dart';
import '../models/record/record_read_model.dart';
import '../network/api_response.dart';
import '../repository/record_repository.dart';

class RecordViewModel with ChangeNotifier {
  final _recordRepo = RecordRepository();

  ApiResponse<dynamic> apiResponse = ApiResponse.loading();

  void setApiResponse(ApiResponse<dynamic> response) {
    apiResponse = response;

    notifyListeners();
  }

  ApiResponse<RecordReadModel> recordData = ApiResponse.loading();

  ApiResponse<RecordReadModel> get getRecordData => recordData;

  ApiResponse<MissionDetailModel> missionDetail = ApiResponse.loading();

  ApiResponse<RecordCreateModel> recordCreate = ApiResponse.loading();

  void setRecordImageList(ApiResponse<RecordReadModel> response) {
    recordData = response;
    notifyListeners();
  }

  void setMissionDetail(ApiResponse<MissionDetailModel> response) {
    missionDetail = response;

    notifyListeners();
  }

  void setCreateRecord(ApiResponse<RecordCreateModel> response) {
    recordCreate = response;

    notifyListeners();
  }

  Future<void> fetchRecordView(Map<String, String> queryParams) async {
    await _recordRepo.getRecordView(queryParams).then((value) {
      setRecordImageList(ApiResponse.complete(value));
      setApiResponse(ApiResponse.complete());
    }).catchError((error, stackTrace) {
      setRecordImageList(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }

  Future<void> createRecord(
      Map<String, String> data, Uint8List? imageBytes) async {
    await _recordRepo.createRecord(data, imageBytes).then((value) {
      if (value.code != 0) {
        setMissionDetail(
            ApiResponse.error("Error: Unexpected response code ${value.code}"));
        setApiResponse(ApiResponse.error());
      } else {
        setApiResponse(ApiResponse.complete());
        setCreateRecord(ApiResponse.complete(value));
      }
    }).onError((error, stackTrace) {
      setMissionDetail(ApiResponse.error(error.toString()));
      setApiResponse(ApiResponse.error());
      return Future.value(null);
    });
  }

  Future<void> fetchMissionDetail(Map<String, dynamic> queryParams) async {
    await _recordRepo.missionDetail(queryParams).then((value) {
      if (value.code != 0) {
        setMissionDetail(
            ApiResponse.error("Error: Unexpected response code ${value.code}"));
        setApiResponse(ApiResponse.error());
        throw Exception("Error: Unexpected response code ${value.code}");
      } else {
        setApiResponse(ApiResponse.complete());
        setMissionDetail(ApiResponse.complete(value));
      }
    }).onError<Object>((error, stackTrace) {
      setMissionDetail(ApiResponse.error(error.toString()));
      setApiResponse(ApiResponse.error());
      return Future.error(error);
    });
  }
}
