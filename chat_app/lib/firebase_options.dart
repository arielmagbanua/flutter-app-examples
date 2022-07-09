// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/services.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static Future<FirebaseOptions> get currentPlatform async {
    if (kIsWeb) {
      final options = await _getOptions('web');
      return FirebaseOptions.fromMap(options);
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final options = await _getOptions('android');
        return FirebaseOptions.fromMap(options);
      case TargetPlatform.iOS:
        final options = await _getOptions('ios');
        return FirebaseOptions.fromMap(options);
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static _getOptions(String platform) async {
    String optionsStr =
        await rootBundle.loadString('assets/configs/firebase_options.json');

    final options = jsonDecode(optionsStr);

    return options[platform];
  }
}