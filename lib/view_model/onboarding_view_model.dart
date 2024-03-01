import 'package:beyond_seoul/models/onboarding/onboarding_screen_model.dart';
import 'package:beyond_seoul/repository/onboarding_repository.dart';
import 'package:flutter/cupertino.dart';

import '../network/api_response.dart';

class OnboardingViewModel with ChangeNotifier {
  final _onboardingRepo = OnboardingRepository();

  ApiResponse<OnboardingScreenModel> themaData = ApiResponse.loading();

  void setThemaList(ApiResponse<OnboardingScreenModel> response) {
    themaData = response;

    notifyListeners();
  }

  ApiResponse<OnboardingScreenModel> destinationData = ApiResponse.loading();

  void setDestinationList(ApiResponse<OnboardingScreenModel> response) {
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

  Future<void> fetchDestinationListApi() async {
    await _onboardingRepo.getDestinationData().then((value) {
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
