import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Screens/CartScreen.dart';
import 'package:frontend/Screens/LoginScreen.dart';
import 'package:frontend/Screens/WelcomeScreen.dart';
import 'package:frontend/constant.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: Colors.white
    ),
    home: const WelcomeScreen(),
  ));
}
