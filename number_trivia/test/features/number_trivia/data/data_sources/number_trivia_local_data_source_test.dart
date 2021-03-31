import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));

    test(
        'Should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cache.json'));
      // act
      final result = await dataSource.getLastNumberTrivia();

      // assert
      verify(
        mockSharedPreferences
            .getString(NumberTriviaLocalDataSourceImpl.CACHED_NUMBER_TRIVIA),
      );
      expect(result, equals(tNumberTriviaModel));
    });

    test('Should throw CacheException when there is no cached value', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = dataSource.getLastNumberTrivia;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: 'test trivia',
      number: 1,
    );

    test('Should call SharedPreferences to cache the data', () async {
      // act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      // assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        NumberTriviaLocalDataSourceImpl.CACHED_NUMBER_TRIVIA,
        expectedJsonString,
      ));
    });
  });
}
