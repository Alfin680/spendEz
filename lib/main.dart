import 'package:flutter/material.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/login.dart';
import 'package:spendez_main/signup.dart';
import 'package:spendez_main/getStart.dart';
import 'package:spendez_main/sinLog.dart';

void main() {
  runApp(SpendEz());
}

class SpendEz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GetStartedPage(),
        '/onboard': (context) => LoginSelectionPage(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args != null && args.containsKey('user_id')) {
            return MaterialPageRoute(
              builder: (context) => HomeScr(userId: args['user_id']),
            );
          }
        }
        return null;
      },
    );
  }
}
