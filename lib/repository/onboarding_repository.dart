import 'dart:convert';

import '../models/onboarding/destination_list_model.dart';
import '../models/onboarding/theme_list_model.dart';
import '../network/api_url.dart';
import '../network/network_manager.dart';

class OnboardingRepository {
    Future<ThemeListModel> getThemaData() async {
    try {
      dynamic response =
          await NetworkManager.instance.get(ApiUrl.themas);
      
      return ThemeListModel.fromJson(jsonDecode(response));
    } catch (e) {
    
      rethrow;
    }
  }

  Future<DestinationListModel> getDestinationData() async {
    try {
      dynamic response =
          await NetworkManager.instance.get(ApiUrl.destinations);
      return DestinationListModel.fromJson(jsonDecode(response));
    } catch (e) {
      rethrow;
    }
  }
}
