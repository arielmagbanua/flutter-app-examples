import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider_firebase/pages/add_task_page.dart';
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
          final userService = UserService();

          return MultiProvider(
            providers: [
              Provider(create: (context) => userService),
              Provider(create: (context) => DatabaseService()),
            ],
            child: MaterialApp.router(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              routerConfig: router(
                AuthRefreshStreamNotifier(
                    FirebaseAuth.instance.authStateChanges()),
                userService,
              ),
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

class AuthRefreshStreamNotifier extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  AuthRefreshStreamNotifier(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
          (_) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }
}

GoRouter router(
  AuthRefreshStreamNotifier authRefreshStream,
  UserService userService,
) {
  return GoRouter(
    initialLocation: '/tasks',
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (_, state) => const TasksPage(),
        routes: [
          GoRoute(
            path: 'add-task',
            builder: (_, state) => const AddTaskPage(),
          ),
        ],
      ),
    ],
    refreshListenable: authRefreshStream,
    redirect: (_, state) {
      if (userService.currentUser == null) {
        // redirect to login page if the user is not at the login page
        return state.subloc == '/login' ? null : '/login';
      }

      if (userService.currentUser != null) {
        if (state.subloc == '/login') {
          // still in login then redirect to tasks page
          return '/tasks';
        }

        return state.subloc != '/tasks' ? state.subloc : '/tasks';
      }

      // do not redirect
      return null;
    },
  );
}
