import 'package:equatable/equatable.dart';
import 'package:weatherapp/features/weather/domain/entities/today_weather/today_weather.dart';

class TodayWeatherData extends Equatable {
  final List<TodayWeather> todayWeatherData;

  TodayWeatherData({required this.todayWeatherData});
  @override
  List<Object?> get props => [todayWeatherData];
}
