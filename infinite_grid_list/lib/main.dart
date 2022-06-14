import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/users/presentation/pages/grid_page.dart';
import 'simple_bloc_observer.dart';
import 'service_container.dart' as sc;

void main() async {
  EquatableConfig.stringify = kDebugMode;

  BlocOverrides.runZoned(
        () {
      runApp(MyApp());
    },
    blocObserver: SimpleBlocObserver(),
  );

  await sc.init();

  // runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Grid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GridPage(),
    );
  }
}
