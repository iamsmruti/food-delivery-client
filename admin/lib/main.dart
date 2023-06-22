import 'package:admin/screens/Authentication&Oboard/login_screen.dart';
import 'package:admin/screens/outlet_mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:admin/constants.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bool isUserLoggedInAlready = FirebaseAuth.instance.currentUser != null;
  runApp(ProviderScope(
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: primaryColor, scaffoldBackgroundColor: Colors.white),
        home: isUserLoggedInAlready ? const OutletMainPage() : const LoginScreen()),
  ));
}
