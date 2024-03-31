import 'dart:convert';

import '../models/onboarding/onboarding_screen_model.dart';
import '../models/onboarding/theme_list_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class OnboardingRepository {
    Future<ThemeListModel> getThemaData() async {
    try {
      dynamic response =
          await NetworkManager.instance.get(ApiUrl.themas);
          print("Jehee455");
      return ThemeListModel.fromJson(jsonDecode(response));
    } catch (e) {
      print("Jehee 123123 ${e}");
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