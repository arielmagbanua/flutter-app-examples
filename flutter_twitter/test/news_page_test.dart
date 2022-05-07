import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_twitter/article.dart';
import 'package:flutter_twitter/news_change_notifier.dart';
import 'package:flutter_twitter/news_page.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_twitter/news_service.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main () {
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

  testWidgets('title is displayed', (WidgetTester tester) async {
    arrangeNewsServiceReturns3Articles();

    await tester.pumpWidget(createWidgetUnderTest());
    
    expect(find.text('News'), findsOneWidget);
  });
}
