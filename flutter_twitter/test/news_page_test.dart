import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitter/article.dart';
import 'package:flutter_twitter/news_change_notifier.dart';
import 'package:flutter_twitter/news_page.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_twitter/news_service.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  final articlesFromService = [
    Article(title: 'Test 1', content: 'Test 1 content'),
    Article(title: 'Test 2', content: 'Test 2 content'),
    Article(title: 'Test 3', content: 'Test 3 content')
  ];

  void arrangeNewsServiceReturns3Articles() {
    when(() => mockNewsService.getArticles()).thenAnswer(
      (_) async => articlesFromService,
    );
  }

  void arrangeNewsServiceReturns3ArticlesAfter2SecondsWait() {
    when(() => mockNewsService.getArticles()).thenAnswer(
          (_) async {
            await Future.delayed(const Duration(seconds: 2));
            return articlesFromService;
          },
    );
  }

  setUp(() {
    mockNewsService = MockNewsService();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'News App',
      home: ChangeNotifierProvider(
        create: (_) => NewsChangeNotifier(mockNewsService),
        child: NewsPage(),
      ),
    );
  }

  testWidgets('title is displayed', (WidgetTester tester) async {
    arrangeNewsServiceReturns3Articles();

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('News'), findsOneWidget);
  });

  testWidgets('loading indicator is displayed while waiting for articles',
      (WidgetTester tester) async {
        arrangeNewsServiceReturns3ArticlesAfter2SecondsWait();

        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump(const Duration(milliseconds: 500));

        expect(find.byKey(const Key('progress-indicator')), findsOneWidget);

        await tester.pumpAndSettle();
      });

  testWidgets('articles displayed', (WidgetTester tester) async {
    arrangeNewsServiceReturns3Articles();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    for (final article in articlesFromService) {
      expect(find.text(article.title), findsOneWidget);
      expect(find.text(article.content), findsOneWidget);
    }
  });
}
