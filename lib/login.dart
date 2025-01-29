// import 'package:flutter/material.dart';

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 32.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "SPENDEZ Login",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Image.asset(
//                 'assets/log.png',
//                 height: 250,
//               ),
//               SizedBox(height: 16),
//               // Email Field
//               TextField(
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   hintText: "Enter your email",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Password Field
//               TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   hintText: "Enter your password",
//                   suffixIcon: Icon(Icons.visibility_outlined),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton(
//                   onPressed: () {
//                     // Forgot password action
//                   },
//                   child: Text(
//                     "Forgot Password?",
//                     style: TextStyle(
//                         color: const Color.fromARGB(255, 21, 18, 226)),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 16),
//               // Login Button with gradient
//               Container(
//                 width: double.infinity,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.transparent,
//                     shadowColor: Colors.transparent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   ),
//                   onPressed: () {
//                     // Login action
//                     Navigator.pushNamed(context, '/home');
//                   },
//                   child: Text(
//                     "LOGIN",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spendez_main/resetPass.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errorMessage = "";

  // Function to handle login request
  Future<void> _login() async {
    // Validate fields
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please fill in both fields.";
      });
      return;
    }

    // API request
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:5000/login'), // Replace with your backend URL
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // If login is successful, navigate to the home page
        Navigator.pushNamed(context, '/home');
      } else {
        // If login fails, show error message
        setState(() {
          _errorMessage = "Invalid username or password.";
        });
      }
    } catch (e) {
      print("Error: $e"); // Print the error for debugging
      setState(() {
        _errorMessage = "An error occurred. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SPENDEZ Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Image.asset(
                'assets/log.png',
                height: 250,
              ),
              SizedBox(height: 16),
              // Email Field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Password Field
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  suffixIcon: Icon(Icons.visibility_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: const Color.fromARGB(255, 21, 18, 226)),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Display error message if any
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 16),
              // Login Button with gradient
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF7F07FF), Color(0xFF4C0499)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _login,
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
