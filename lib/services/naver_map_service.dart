import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class NaverMapService {
  static const String _mapBaseUrl =
      'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster';

  static const String _reverseGeocodeUrl =
      'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc';

      static const _clientId = 'ec8tg98xwg';
      static const _clientSecret = 'tm5ltblG6H0fmUaqvVTX2XUqd4aRHaUIrfUUdd8Y';

  static Future<Uint8List?> getStaticMapImage(double lat, double lon,
      {int level = 17,
      int width = 600,
      int height = 400,
      String format = 'png'}) async {
    final response = await http.get(
      Uri.parse(
          '$_mapBaseUrl?center=$lon,$lat&level=$level&w=$width&h=$height&format=$format&markers=type:d|size:mid|pos:$lon%20$lat'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Failed to load static map: ${response.statusCode}');
      return null;
    }
  }

  static Future<String?> getAddressFromLatLng(double lat, double lon) async {
    print("Jehee ${lat} ${lon}");
    final response = await http.get(
      Uri.parse(
          '$_reverseGeocodeUrl?coords=$lon,$lat&output=json'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': _clientId,
        'X-NCP-APIGW-API-KEY': _clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('API Response: $json');
      if (json['results'] != null && json['results'].isNotEmpty) {
        final area = json['results'][0]['region'];
        final String address =
            '${area['area1']['name']} ${area['area2']['name']} ${area['area3']['name']}';
        return address;
      } else {
        print('No address found in results');
      }
    } else {
      print('Failed to load address: ${response.statusCode}');
    }
    return null;
  }
}
