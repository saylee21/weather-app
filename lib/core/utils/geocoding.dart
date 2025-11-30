import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/core/constant/api_key.dart'; // Adjust if your API key path differs
import 'package:weatherapp/core/error/exceptions.dart';
import 'package:weatherapp/core/utils/lat_long.dart';

Future<LatLong> getLatLongFromCity(String cityName) async {
  if (cityName.isEmpty) {
    throw LocationException();
  }

  final url = "https://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=$API_KEY";
  print('🔗 [GEOCODING] URL: $url');

  try {
    final response = await http.get(Uri.parse(url));

    print('📡 [GEOCODING] Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      if (data.isNotEmpty) {
        final geo = data[0];
        return LatLong(
          lat: geo['lat'].toDouble(),
          long: geo['lon'].toDouble(),
        );
      } else {
        throw LocationException();
      }
    } else {
      print('❌ [GEOCODING] Error: ${response.body}');
      throw ServerException();
    }
  } catch (e, stackTrace) {
    print('💥 [GEOCODING] Exception: $e');
    print('📚 [GEOCODING] Stack trace: $stackTrace');
    throw ServerException();
  }
}