import 'package:flutter/material.dart';

class Sinlog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginSelectionPage(),
    );
  }
}

class LoginSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/onBG.png',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Text
              const Padding(
                padding: EdgeInsets.only(
                    top: 100.0,
                    left: 24.0), // Add left padding to move the text
                child: Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text(
                    "Manage your Finance \nat your fingertips with",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
              // Bottom Buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Signup Button
                    Container(
                      width: 293,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Spacing between buttons
                    // Login Button
                    Container(
                      width: 293,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEDEFF),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Color(0xFF5E06BC)),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle login action
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 103),
                          backgroundColor: Color(0xFFEEDEFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5E06BC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
