import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:features.number_trivia/core/usecases/usecase.dart';
import 'package:features.number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:features.number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:features.number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {
}

main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final nNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('Should get trivia from the repository', () async {
    // arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_)  async => Right(nNumberTrivia));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, Right(nNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
