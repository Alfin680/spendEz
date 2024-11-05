import 'package:flutter/material.dart';

class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns content to the left
            children: [
              // Heading Text
              Text(
                "Struggling to manage your Finances?",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 40),

              // Center the Illustration Image
              Center(
                child: Image.asset(
                  'assets/pana.png', // Replace with the path to your asset
                  height: 300,
                  width: 300,
                ),
              ),
              SizedBox(height: 40),

              // Supportive Text
              Text(
                "Don’t worry, we got\nyou covered",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),

              // Center the Get Started Button
              Center(
                child: SizedBox(
                  width: 314,
                  height: 66,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF7F07FF),
                          Color(0xFF4C0499),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context,
                            '/onboard'); // Change to your intended route
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        "GET STARTED",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
