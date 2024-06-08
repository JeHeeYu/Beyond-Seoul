import 'dart:typed_data';
import 'package:http/http.dart' as http;

class NaverMapService {

  static const String _mapBaseUrl =
      'https://naveropenapi.apigw.ntruss.com/map-static/v2/raster';

  static Future<Uint8List?> getStaticMapImage(double lat, double lon,
      {int level = 17,
      int width = 600,
      int height = 400,
      String format = 'png'}) async {
    final response = await http.get(
      Uri.parse(
          '$_mapBaseUrl?center=$lon,$lat&level=$level&w=$width&h=$height&format=$format&markers=type:d|size:mid|pos:$lon%20$lat'),
      headers: {
        'X-NCP-APIGW-API-KEY-ID': 'ec8tg98xwg',
        'X-NCP-APIGW-API-KEY': 'tm5ltblG6H0fmUaqvVTX2XUqd4aRHaUIrfUUdd8Y',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print('Failed to load static map: ${response.statusCode}');
    }
  }
}
