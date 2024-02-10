import 'dart:convert';

import '../models/onboarding/onboarding_screen_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class OnboardingRepository {
    Future<OnboardingScreenModel> getThemaData() async {
    try {
      dynamic response =
          await NetworkManager.instance.get(ApiUrl.themas);
      return OnboardingScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<OnboardingScreenModel> getDestinationData() async {
    try {
      dynamic response =
          await NetworkManager.instance.get(ApiUrl.destinations);
      return OnboardingScreenModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}