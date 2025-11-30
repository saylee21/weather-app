import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/weather_usecase/weather_params.dart';
import '../../../../core/usecases/weather_usecase/weather_usecase.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

class GetWeather implements WeatherUseCase<Weather, WeatherParams> {
  final WeatherRepository repository;

  GetWeather(this.repository);
  @override
  Future<Either<Failure, Weather>> call(WeatherParams params) async {
    return await repository.getWeather(params.latLong);
  }
}
