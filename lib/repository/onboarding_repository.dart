import 'dart:convert';

import '../models/onboarding/destination_list_model.dart';
import '../models/onboarding/onboarding_complete_model.dart';
import '../models/onboarding/theme_list_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class OnboardingRepository {
  Future<ThemeListModel> getThemaData() async {
    try {
      dynamic response = await NetworkManager.instance.get(ApiUrl.themas);

      return ThemeListModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<DestinationListModel> getDestinationData(
      Map<String, String> queryParams) async {
    try {
      dynamic response = await NetworkManager.instance
          .getQuery(ApiUrl.destinations, queryParams);
      return DestinationListModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<OnboardingCompleteModel> onboardingComplete(String url,
      Map<String, dynamic> data) async {
    try {
      dynamic response =
          await NetworkManager.instance.post(url, data);
      return OnboardingCompleteModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
