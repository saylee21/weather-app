import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/core/utils/lat_long.dart';

import '../../../../core/constant/api_key.dart';
import '../../../../core/error/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDataSource {
  Future<WeatherModel> getWeather(LatLong latLong);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;

  WeatherRemoteDataSourceImpl({required this.client});

  @override
  Future<WeatherModel> getWeather(LatLong latLong) async {
    print('🌤️ [WEATHER API] Starting weather fetch...');
    print('📍 [WEATHER API] Lat: ${latLong.lat}, Long: ${latLong.long}');

    try {
      // Call 1: Get current weather
      final currentWeatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=${latLong.lat}&lon=${latLong.long}&units=metric&appid=$API_KEY";
      print('🔗 [WEATHER API] Current Weather URL: $currentWeatherUrl');

      final currentResponse = await client.get(
        Uri.parse(currentWeatherUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 [WEATHER API] Current Weather Status: ${currentResponse.statusCode}');
      print('📦 [WEATHER API] Current Response Body (first 200 chars): ${currentResponse.body.substring(0, currentResponse.body.length > 200 ? 200 : currentResponse.body.length)}');

      if (currentResponse.statusCode != 200) {
        print('❌ [WEATHER API] Current weather error: ${currentResponse.body}');
        throw ServerException();
      }

      // Call 2: Get 5-day forecast
      final forecastUrl = "https://api.openweathermap.org/data/2.5/forecast?lat=${latLong.lat}&lon=${latLong.long}&units=metric&appid=$API_KEY";
      print('🔗 [WEATHER API] Forecast URL: $forecastUrl');

      final forecastResponse = await client.get(
        Uri.parse(forecastUrl),
        headers: {'Content-Type': 'application/json'},
      );

      print('📡 [WEATHER API] Forecast Status: ${forecastResponse.statusCode}');
      print('📦 [WEATHER API] Forecast Response Body (first 200 chars): ${forecastResponse.body.substring(0, forecastResponse.body.length > 200 ? 200 : forecastResponse.body.length)}');

      if (forecastResponse.statusCode != 200) {
        print('❌ [WEATHER API] Forecast error: ${forecastResponse.body}');
        throw ServerException();
      }

      // Combine both responses
      final currentWeatherData = json.decode(currentResponse.body);
      final forecastData = json.decode(forecastResponse.body);

      print('✅ [WEATHER API] Both APIs succeeded! Parsing...');

      // Merge data for your model
      final combinedData = {
        'current': currentWeatherData,
        'forecast': forecastData,
      };

      final weatherModel = WeatherModel.fromJson(combinedData);
      print('✅ [WEATHER API] Weather model created successfully');
      return weatherModel;

    } catch (e, stackTrace) {
      print('💥 [WEATHER API] Exception: $e');
      print('📚 [WEATHER API] Stack trace: $stackTrace');
      throw ServerException();
    }
  }
}