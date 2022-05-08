import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitter/article.dart';
import 'package:flutter_twitter/article_page.dart';
import 'package:flutter_twitter/news_change_notifier.dart';
import 'package:flutter_twitter/news_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../test/news_change_notifier_test.dart';

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

  testWidgets(
      'Tapping on the first article excerpt opens the article page where the full article content is displayed',
      (WidgetTester tester) async {
        arrangeNewsServiceReturns3Articles();

        await tester.pumpWidget(createWidgetUnderTest());

        await tester.pump();

        // tap the first article
        await tester.tap(find.text('Test 1 content'));

        await tester.pumpAndSettle();

        // expects that no longer in the news page
        expect(find.byType(NewsPage), findsNothing);

        // expects that navigated to the article page
        expect(find.byType(ArticlePage), findsOneWidget);

        expect(find.text('Test 1'), findsOneWidget);
        expect(find.text('Test 1 content'), findsOneWidget);
      });
}
