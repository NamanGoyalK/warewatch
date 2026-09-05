import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:warewatch/app.dart';
import 'package:warewatch/core/services/firebase_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize Firebase
  await FirebaseInitializer.initialize();
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '872335024678-i8vh0nbkfm5s44ch6n8poqh8fdh4kp7v.apps.googleusercontent.com',
  );

  await dotenv.load(fileName: ".env");

  runApp(const MainApp());
}
