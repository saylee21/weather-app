import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/location/get_lat_long.dart';
import '../../../../core/usecases/weather_usecase/weather_params.dart';
import '../../../../core/utils/geocoding.dart'; // Import the new geocoding util
import '../../domain/entities/weather.dart';
import '../../domain/usecases/get_weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

const String LOCATION_FAILURE_MESSAGE = "Unable to get the Location";
const String SERVER_FAILURE_MESSAGE = "Unable to get data from database";
const String CITY_NOT_FOUND_MESSAGE = "City not found";

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  final GetLatLong getLatLong;
  @override
  WeatherState get initialState => Empty();

  WeatherBloc({
    required this.getLatLong,
    required this.getWeather,
  }) : super(Empty()) {
    on<WeatherEvent>((event, emit) {});

    on<GetWeatherForLatLong>((event, emit) async {
      final latLongEither = await getLatLong.getLatLong();

      await latLongEither.fold((failure) {
        emit(Error(message: LOCATION_FAILURE_MESSAGE));
      }, (latLong) async {
        emit(Loading());
        final failureOrWeather = await getWeather(WeatherParams(latLong: latLong));
        failureOrWeather.fold((failure) {
          emit(Error(message: SERVER_FAILURE_MESSAGE));
        }, (weather) {
          emit(Loaded(
            weather: weather,
            latitude: latLong.lat,    // ADD THIS
            longitude: latLong.long,  // ADD THIS
          ));
        });
      });
    });

    on<GetWeatherForCity>((event, emit) async {
      emit(Loading());
      try {
        final latLong = await getLatLongFromCity(event.city);
        final failureOrWeather = await getWeather(WeatherParams(latLong: latLong));
        failureOrWeather.fold((failure) {
          emit(Error(message: SERVER_FAILURE_MESSAGE));
        }, (weather) {
          emit(Loaded(
            weather: weather,
            latitude: latLong.lat,    // ADD THIS
            longitude: latLong.long,  // ADD THIS
          ));
        });
      } catch (e) {
        emit(Error(message: CITY_NOT_FOUND_MESSAGE));
      }
    });
  }
}