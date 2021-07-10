import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import './widgets/streaming_status.dart';
import './widgets/location_permission.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Permission',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Location Permission'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> createWidgetList() {
    final List<Widget> widgets = LocationPermissionLevel.values
        .map<Widget>((LocationPermissionLevel level) => LocationPermission(level))
        .toList();

    if (Platform.isAndroid) {
      widgets.add(StreamingStatus());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              LocationPermissions().openAppSettings().then((bool hasOpened) =>
                  debugPrint('App Settings opened: ' + hasOpened.toString()));
            },
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: createWidgetList(),
        ),
      ),
    );
  }
}
