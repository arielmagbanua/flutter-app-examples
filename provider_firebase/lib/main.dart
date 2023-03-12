import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login.dart';
import 'screens/tasks.dart';
import 'screens/error.dart';
import 'screens/loading.dart';

void main() {
  // ensure widgets binding are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // hold the future result of initialization.
  final _initFirebaseApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFirebaseApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // something went wrong therefore display the error page
          return MaterialApp(
            title: 'Firebase Error',
            theme: ThemeData(
              primarySwatch: Colors.red,
            ),
            home: Error(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider<User?>.value(
                value: FirebaseAuth.instance.authStateChanges(),
                initialData: null,
              )
            ],
            child: MaterialApp.router(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              routerConfig: router(),
            ),
          );
        }

        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const Loading(),
        );
      },
    );
  }
}

GoRouter router() {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const Tasks(),
      ),
    ],
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
