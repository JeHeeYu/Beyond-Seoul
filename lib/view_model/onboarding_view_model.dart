import 'package:beyond_seoul/models/onboarding/destination_list_model.dart';
import 'package:beyond_seoul/repository/onboarding_repository.dart';
import 'package:flutter/cupertino.dart';

import '../models/onboarding/theme_list_model.dart';
import '../network/api_response.dart';

class OnboardingViewModel with ChangeNotifier {
  final _onboardingRepo = OnboardingRepository();

  ApiResponse<ThemeListModel> themaData = ApiResponse.loading();

  void setThemaList(ApiResponse<ThemeListModel> response) {
    themaData = response;

    notifyListeners();
  }

  ApiResponse<DestinationListModel> destinationData = ApiResponse.loading();

  void setDestinationList(ApiResponse<DestinationListModel> response) {
    destinationData = response;

    notifyListeners();
  }

  Future<void> fetchThemaListApi() async {
    await _onboardingRepo.getThemaData().then((value) {
      if (value.code != 0) {
        setThemaList(
            ApiResponse.error("Error: Unexpected response code ${value.code}"));
      } else {
        setThemaList(ApiResponse.complete(value));
      }
    }).onError((error, stackTrace) {
      setThemaList(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }

  Future<void> fetchDestinationListApi(Map<String, String> queryParams) async {
    await _onboardingRepo.getDestinationData(queryParams).then((value) {
      if (value.code != 0) {
        setDestinationList(
            ApiResponse.error("Error: Unexpected response code ${value.code}"));
      } else {
        setDestinationList(ApiResponse.complete(value));

      }
    }).onError((error, stackTrace) {
      setDestinationList(ApiResponse.error(error.toString()));
      return Future.value(null);
    });
  }
}
