import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  // void runTestsOnline(Function body) {
  //   group('Device is online', () {
  //     setUp(() {
  //       mockNetworkInfo = MockNetworkInfo();
  //       when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
  //     });
  //
  //     body();
  //   });
  // }

  void runTestsOffline(Function body) {
    group('Device is offline', () {
      setUp(() {
        mockNetworkInfo = MockNetworkInfo();
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: tNumber,
    );

    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    // test('Should check if the device is online', () async {
    //   // arrange
    //   when(() => mockNetworkInfo.isConnected)
    //       .thenAnswer((_) async => true);
    //   when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
    //           .thenAnswer((_) async => tNumberTriviaModel);
    //   when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
    //       .thenAnswer((_) => Future.value());
    //
    //   // act
    //   repository.getConcreteNumberTrivia(tNumber);
    //
    //   // assert
    //   verify(() => mockNetworkInfo.isConnected);
    // });

    // runTestsOnline(() {
    //   test(
    //       'Should return remote data when the call to remote data source is successful',
    //       () async {
    //     // arrange
    //     when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
    //         .thenAnswer((_) async => tNumberTriviaModel);
    //
    //     // act
    //     final result = await repository.getConcreteNumberTrivia(tNumber);
    //
    //     // assert
    //     verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
    //     expect(result, equals(Right(tNumberTrivia)));
    //   });
    //
    //   test(
    //       'Should cache the data locally when the call to remote data source is successful',
    //       () async {
    //     // arrange
    //     when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
    //         .thenAnswer((_) async => tNumberTriviaModel);
    //
    //     // act
    //     await repository.getConcreteNumberTrivia(tNumber);
    //
    //     // assert
    //     verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
    //     verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    //   });
    //
    //   test(
    //       'Should return server failure when the call to remote data source is unsuccessful',
    //       () async {
    //     // arrange
    //     when(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber))
    //         .thenThrow(ServerException());
    //
    //     // act
    //     final result = await repository.getConcreteNumberTrivia(tNumber);
    //
    //     // assert
    //     verify(() => mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
    //     verifyZeroInteractions(mockLocalDataSource);
    //     expect(result, equals(Left(ServerFailure())));
    //   });
    // });

    runTestsOffline(() {
      test(
          'Should return last locally cached data when the cached data is present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) async => false);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test('Should return CacheFailure when there is cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        when(() => mockNetworkInfo.isConnected)
            .thenAnswer((_) async => false);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 123,
    );

    // final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('Should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);
      when(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) => Future.value());

      // act
      repository.getRandomNumberTrivia();

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    // runTestsOnline(() {
    //   test(
    //       'Should return remote data when the call to remote data source is successful',
    //       () async {
    //     // arrange
    //     when(() => mockRemoteDataSource.getRandomNumberTrivia())
    //         .thenAnswer((_) async => tNumberTriviaModel);
    //
    //     // act
    //     final result = await repository.getRandomNumberTrivia();
    //
    //     // assert
    //     verify(() => mockRemoteDataSource.getRandomNumberTrivia());
    //     expect(result, equals(Right(tNumberTrivia)));
    //   });
    //
    //   test(
    //       'Should cache the data locally when the call to remote data source is successful',
    //       () async {
    //     // arrange
    //     when(() => mockRemoteDataSource.getRandomNumberTrivia())
    //         .thenAnswer((_) async => tNumberTriviaModel);
    //
    //     // act
    //     await repository.getRandomNumberTrivia();
    //
    //     // assert
    //     verify(() => mockRemoteDataSource.getRandomNumberTrivia());
    //     verify(() => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    //   });
    //
    //   test(
    //       'Should return server failure when the call to remote data source is unsuccessful',
    //       () async {
    //     // arrange
    //     when(() => mockRemoteDataSource.getRandomNumberTrivia())
    //         .thenThrow(ServerException());
    //
    //     // act
    //     final result = await repository.getRandomNumberTrivia();
    //
    //     // assert
    //     verify(() => mockRemoteDataSource.getRandomNumberTrivia());
    //     verifyZeroInteractions(mockLocalDataSource);
    //     expect(result, equals(Left(ServerFailure())));
    //   });
    // });

    // runTestsOffline(() {
    //   test(
    //       'Should return last locally cached data when the cached data is present',
    //       () async {
    //     // arrange
    //     when(() => mockLocalDataSource.getLastNumberTrivia())
    //         .thenAnswer((_) async => tNumberTriviaModel);
    //
    //     // act
    //     final result = await repository.getRandomNumberTrivia();
    //
    //     // assert
    //     verifyZeroInteractions(mockRemoteDataSource);
    //     verify(() => mockLocalDataSource.getLastNumberTrivia());
    //     expect(result, equals(Right(tNumberTrivia)));
    //   });
    //
    //   test('Should return CacheFailure when there is cached data present',
    //       () async {
    //     // arrange
    //     when(() => mockLocalDataSource.getLastNumberTrivia())
    //         .thenThrow(CacheException());
    //
    //     // act
    //     final result = await repository.getRandomNumberTrivia();
    //
    //     // assert
    //     verifyZeroInteractions(mockRemoteDataSource);
    //     verify(() => mockLocalDataSource.getLastNumberTrivia());
    //     expect(result, equals(Left(CacheFailure())));
    //   });
    // });
  });
}
