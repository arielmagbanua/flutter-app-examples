import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider_firebase/services/database_service.dart';
import 'package:provider_firebase/services/user_service.dart';

import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/tasks_page.dart';
import 'pages/error_page.dart';
import 'pages/loading_page.dart';

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
            home: ErrorPage(snapshot.error.toString()),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider<User?>.value(
                value: FirebaseAuth.instance.authStateChanges(),
                initialData: null,
              ),
              Provider(create: (context) => UserService()),
              Provider(create: (context) => DatabaseService()),
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
          home: const LoadingPage(),
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
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      var user = Provider.of<User?>(context);

      if (user != null) {
        return '/tasks';
      }

      return '/login';
    }
  );
}
