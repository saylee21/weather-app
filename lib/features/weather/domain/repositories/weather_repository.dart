import 'package:dartz/dartz.dart';
import 'package:weatherapp/core/utils/lat_long.dart';
import '../../../../core/error/failures.dart';
import '../entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getWeather(LatLong latLong);
}
