import 'package:dartz/dartz.dart';

import 'package:features.number_trivia/core/error/failures.dart';
import 'package:features.number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, NumberTrivia>> call(Params params);
}
