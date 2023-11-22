import 'package:flutter/material.dart';

import '../models/home/home_screen_model.dart';
import '../models/home/travel_model.dart';
import '../network/api_response.dart';
import '../repository/home_repository.dart';

class HomeViewModel with ChangeNotifier {
  final _homeRepo = HomeRepository();

  ApiResponse<HomeScreenModel> travelList = ApiResponse.loading();

  void setTravelList(ApiResponse<HomeScreenModel> response) {
    travelList = response;
    notifyListeners();
  }

  Future<void> fetchTravelListApi() async {
    await _homeRepo.getTravel().then((value) {
      setTravelList(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setTravelList(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }
}
