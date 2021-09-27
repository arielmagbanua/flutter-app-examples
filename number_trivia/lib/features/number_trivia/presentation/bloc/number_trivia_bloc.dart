import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part './number_trivia_event.dart';

part './number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failure';
const String CACHE_FAILURE_MESSAGE = 'Cache failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected error.';
  }
}

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : this.getConcreteNumberTrivia = concrete,
        this.getRandomNumberTrivia = random,
        super(Empty()) {
    on<GetTriviaForConcreteNumber>(
      (GetTriviaForConcreteNumber event, emit) {
        final inputEither = inputConverter.stringToUnsignedInteger(
          event.numberString,
        );

        inputEither.fold(
          (failure) async* {
            emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          },
          (integer) async* {
            emit(Loading());
            final failureOrTrivia = await getConcreteNumberTrivia(
              Params(number: integer),
            );

            emit(
              failureOrTrivia.fold(
                (failure) => Error(message: _mapFailureToMessage(failure)),
                (trivia) => Loaded(trivia: trivia),
              ),
            );
          },
        );
      },
    );

    on<GetTriviaForRandomNumber>(
      (GetTriviaForRandomNumber event, emit) async {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        emit(
          failureOrTrivia.fold(
            (failure) => Error(message: _mapFailureToMessage(failure)),
            (trivia) => Loaded(trivia: trivia),
          ),
        );
      },
    );
  }
}

/*
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : this.getConcreteNumberTrivia = concrete,
        this.getRandomNumberTrivia = random,
        super(Empty());

  @override
  Stream<NumberTriviaState> mapEventToState(NumberTriviaEvent event) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          yield Loading();
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));
          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error.';
    }
  }
}
*/
