import 'package:flutter/material.dart';

import '../models/home/home_screen_model.dart';
import '../models/home/mate_code_screen_model.dart';
import '../models/home/travel_model.dart';
import '../network/api_response.dart';
import '../repository/home_repository.dart';

class HomeViewModel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<HomeScreenModel> homeData = ApiResponse.loading();
  ApiResponse<MateCodeScreenModel> mateCodeData = ApiResponse.loading();

  void setTravelList(ApiResponse<HomeScreenModel> response) {
    homeData = response;

    notifyListeners();
  }

  void setMadeCode(ApiResponse<MateCodeScreenModel> response) {
    mateCodeData = response;

    notifyListeners();
  }

  ApiResponse<HomeScreenModel> get getHomeData => homeData;

  Future<void> fetchTravelListApi() async {
    await _homeRepo.getHomeScreenData().then((value) {
      if (value.code != 0) {
        setTravelList(
            ApiResponse.error("Error: Unexpected response code ${value.code}"));
      } else {
        setTravelList(ApiResponse.complete(value));
      }
    }).onError((error, stackTrace) {
      setTravelList(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }

  Future<void> fetchMateCodetApi() async {
    await _homeRepo.getMateCode().then((value) {
      setMadeCode(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setMadeCode(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }
}
