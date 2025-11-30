import 'package:dartz/dartz.dart';
import '../../error/failures.dart';

abstract class WeatherUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}
