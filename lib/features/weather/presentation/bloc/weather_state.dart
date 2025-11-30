part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class Empty extends WeatherState {}

class Loading extends WeatherState {}

class Loaded extends WeatherState {
  final Weather weather;
  final double latitude;   // ADD THIS
  final double longitude;  // ADD THIS

  const Loaded({
    required this.weather,
    required this.latitude,   // ADD THIS
    required this.longitude,  // ADD THIS
  });

  @override
  List<Object> get props => [weather, latitude, longitude];  // UPDATE THIS
}

class Error extends WeatherState {
  final String message;

  const Error({required this.message});

  @override
  List<Object> get props => [message];
}