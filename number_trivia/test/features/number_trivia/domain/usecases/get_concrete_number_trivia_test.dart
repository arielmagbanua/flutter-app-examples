import 'package:dartz/dartz.dart';
import 'package:features.number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:features.number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:features.number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {

}

main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final nNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('Should get trivia for the number from the repository', () async {
    // arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((_)  async => Right(nNumberTrivia));

    // act
    final result = await usecase(number: tNumber);

    // assert
    expect(result, Right(nNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
