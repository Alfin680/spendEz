import 'package:flutter/material.dart';
import 'package:spendez_main/home.dart';
import 'package:spendez_main/login.dart';
import 'package:spendez_main/signup.dart';
import 'package:spendez_main/getStart.dart';
import 'package:spendez_main/sinLog.dart';
import 'package:spendez_main/shared_pref.dart'; // Import SharedPrefs

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init(); // Initialize SharedPreferences
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
      initialRoute: SharedPrefs().getLoggedIn() ? '/home' : '/', // Check login status
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
          } else {
            // If no arguments are passed, use the saved user ID
            final userId = SharedPrefs().getUserId();
            return MaterialPageRoute(
              builder: (context) => HomeScr(userId: userId),
            );
          }
        }
        return null;
      },
    );
  }
}