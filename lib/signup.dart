import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title Text
              Text(
                'SPENDEZ Signup',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),

              // Placeholder for Image
              Image.asset(
                'assets/amico.png', // Place your asset image here
                height: 200,
              ),
              SizedBox(height: 20),

              // Name TextField
              buildTextField(label: 'Name', hintText: 'Enter your Name'),
              SizedBox(height: 15),

              // Email TextField
              buildTextField(label: 'Email', hintText: 'Enter your Email'),
              SizedBox(height: 15),

              // Password TextField
              buildPasswordField(
                  label: 'Password', hintText: 'Enter a new password'),
              SizedBox(height: 15),

              // Confirm Password TextField
              buildTextField(
                label: 'Confirm Password',
                hintText: 'Retype your new password',
                isPassword: true,
              ),
              SizedBox(height: 30),

              // Signup Button with Stroke
              SizedBox(
                width: 342,
                height: 55,
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
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Transparent background
                      shadowColor: Colors
                          .transparent, // Remove shadow to keep gradient clear
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    child: Text(
                      'SIGNUP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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

  Widget buildTextField({
    required String label,
    required String hintText,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide:
                    BorderSide(color: Color(0xFFAAA1A1)), // Border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Color(0xFFAAA1A1), width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField({
    required String label,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color.fromARGB(255, 255, 255, 255),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide:
                    BorderSide(color: Color(0xFFAAA1A1)), // Border color
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Color(0xFFAAA1A1), width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
