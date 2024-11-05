import 'package:flutter/material.dart';
import 'package:spendez_main/homeScreen.dart';
import 'package:spendez_main/login.dart';
import 'package:spendez_main/signup.dart';
import 'package:spendez_main/getStart.dart';
import 'package:spendez_main/sinLog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/', // Set SignUpScreen as initial route for now
      routes: {
        '/': (context) => GetStartedPage(),
        '/onboard': (context) => LoginSelectionPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

// Placeholder widgets for Get Started, Login, and Home pages


