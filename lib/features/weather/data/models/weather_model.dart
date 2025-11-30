import 'package:intl/intl.dart';
import 'package:weatherapp/core/utils/find_icon.dart';
import 'package:weatherapp/features/weather/domain/entities/current_weather/current_weather.dart';
import 'package:weatherapp/features/weather/domain/entities/current_weather/current_weather_data.dart';
import 'package:weatherapp/features/weather/domain/entities/seven_day_weather/seven_day_weather.dart';
import 'package:weatherapp/features/weather/domain/entities/seven_day_weather/seven_day_weather_data.dart';
import 'package:weatherapp/features/weather/domain/entities/today_weather/today_weather.dart';
import 'package:weatherapp/features/weather/domain/entities/today_weather/today_weather_data.dart';
import 'package:weatherapp/features/weather/domain/entities/weather.dart';

class WeatherModel extends Weather {
  WeatherModel({
    required CurrentWeatherData currentWeatherData,
    required SevenDayWeatherData sevenDayWeatherData,
    required TodayWeatherData todayWeatherData,
  }) : super(
    currentWeatherData: currentWeatherData,
    sevenDayWeatherData: sevenDayWeatherData,
    todayWeatherData: todayWeatherData,
  );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    print('🔄 [WEATHER MODEL] Parsing JSON...');

    DateTime date = DateTime.now();
    var currentData = json["current"];
    var forecastList = json["forecast"]["list"] as List<dynamic>;

    // Parse current weather
    CurrentWeather currentTemp = CurrentWeather(
      current: (currentData["main"]["temp"] as num).round(),
      name: currentData["weather"][0]["main"].toString(),
      day: DateFormat("EEEE dd MMMM").format(date),
      wind: (currentData["wind"]["speed"] as num?)!.round(),
      humidity: (currentData["main"]["humidity"] as num?)!.round(),
      chanceRain: forecastList.isNotEmpty && forecastList[0]["pop"] != null
          ? ((forecastList[0]["pop"] as num) * 100).round()
          : 0,
      image: findIcon(currentData["weather"][0]["main"].toString(), true),
      city: currentData["name"] ?? 'Unknown',
    );

    // Parse today/hourly weather (next 4 forecast items, approx 3-hourly)
    List<TodayWeather> todayWeather = [];
    for (var i = 0; i < 4 && i < forecastList.length; i++) {
      var item = forecastList[i];
      var itemTime = DateTime.fromMillisecondsSinceEpoch(item["dt"] * 1000);
      var hourly = TodayWeather(
        current: (item["main"]["temp"] as num).round(),
        image: findIcon(item["weather"][0]["main"].toString(), false),
        time: DateFormat("HH:mm").format(itemTime),
      );
      todayWeather.add(hourly);
    }

    // Aggregate daily forecast for 5 days
    Map<String, dynamic> dailyData = {};
    for (var item in forecastList) {
      var itemDate = DateTime.fromMillisecondsSinceEpoch(item["dt"] * 1000);
      var dayKey = DateFormat('yyyy-MM-dd').format(itemDate);
      if (!dailyData.containsKey(dayKey)) {
        dailyData[dayKey] = {
          'temps': <double>[],
          'weather': item["weather"][0],
          'day': DateFormat("EEEE").format(itemDate).substring(0, 3),
        };
      }
      // Cast to double explicitly
      dailyData[dayKey]['temps'].add((item["main"]["temp"] as num).toDouble());
    }

    List<SevenDayWeather> fiveDay = [];
    var sortedDays = dailyData.keys.toList()..sort();
    for (var j = 0; j < sortedDays.length && j < 5; j++) {
      var dayKey = sortedDays[j];
      var d = dailyData[dayKey];
      var temps = d['temps'] as List<double>;
      var maxTemp = temps.reduce((a, b) => a > b ? a : b).round();
      var minTemp = temps.reduce((a, b) => a < b ? a : b).round();
      var weather = d['weather'];
      var daily = SevenDayWeather(
        max: maxTemp,
        min: minTemp,
        image: findIcon(weather["main"].toString(), false),
        name: weather["main"].toString(),
        day: d['day'],
      );
      fiveDay.add(daily);
    }

    print('✅ [WEATHER MODEL] Parsed successfully!');

    return WeatherModel(
      currentWeatherData: CurrentWeatherData(currentWeatherData: currentTemp),
      sevenDayWeatherData: SevenDayWeatherData(sevenDayWeatherdata: fiveDay),
      todayWeatherData: TodayWeatherData(todayWeatherData: todayWeather),
    );
  }
}