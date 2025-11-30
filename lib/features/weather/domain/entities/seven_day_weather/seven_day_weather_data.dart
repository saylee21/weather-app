import 'package:equatable/equatable.dart';
import 'package:weatherapp/features/weather/domain/entities/seven_day_weather/seven_day_weather.dart';

class SevenDayWeatherData extends Equatable {
  final List<SevenDayWeather> sevenDayWeatherdata;

  const SevenDayWeatherData({required this.sevenDayWeatherdata});

  @override
  List<Object?> get props => [sevenDayWeatherdata];
}
