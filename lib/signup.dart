import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spendez_main/home.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen(),
      routes: {
        '/home': (context) => HomeScr(),
      },
    );
  }
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Map<String, String?> _errorMessages = {
    'username': null,
    'email': null,
    'password': null,
    'confirmPassword': null,
  };

  Future<void> _signUp() async {
    setState(() {
      _errorMessages = {
        'username':
            _usernameController.text.isEmpty ? 'Name is required' : null,
        'email': _emailController.text.isEmpty ? 'Email is required' : null,
        'password':
            _passwordController.text.isEmpty ? 'Password is required' : null,
        'confirmPassword': _confirmPasswordController.text.isEmpty
            ? 'Confirm Password is required'
            : (_passwordController.text != _confirmPasswordController.text
                ? 'Passwords do not match'
                : null),
      };
    });

    if (_errorMessages.values.any((msg) => msg != null)) {
      return; // Stop if there are validation errors
    }

    final String url = 'http://10.0.2.2:5000/signup';

    final Map<String, String> signUpData = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(signUpData),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('User signed up successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Sign-up failed: ${response.body}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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
              Text(
                'SPENDEZ Signup',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 20),
              Image.asset('assets/amico.png', height: 200),
              SizedBox(height: 20),
              buildTextField(
                controller: _usernameController,
                label: 'Name',
                hintText: 'Enter your Name',
                errorMessage: _errorMessages['username'],
              ),
              SizedBox(height: 15),
              buildTextField(
                controller: _emailController,
                label: 'Email',
                hintText: 'Enter your Email',
                errorMessage: _errorMessages['email'],
              ),
              SizedBox(height: 15),
              buildPasswordField(
                controller: _passwordController,
                label: 'Password',
                hintText: 'Enter a new password',
                errorMessage: _errorMessages['password'],
              ),
              SizedBox(height: 15),
              buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hintText: 'Retype your new password',
                errorMessage: _errorMessages['confirmPassword'],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 342,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7F07FF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: _signUp,
                  child: Text(
                    'SIGNUP',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
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
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16, color: const Color.fromARGB(221, 0, 0, 0))),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 14)),
          ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(color: Color(0xFFAAA1A1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Color(0xFFAAA1A1), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    String? errorMessage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: const Color.fromARGB(221, 0, 0, 0),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Color(0xFFAAA1A1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Color(0xFFAAA1A1), width: 1.5),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromARGB(255, 0, 0, 0),
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
