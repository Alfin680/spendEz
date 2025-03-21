// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:spendez_main/home.dart';

// class Signup extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SignUpScreen(),
//     );
//   }
// }

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   bool _isPasswordVisible = false;
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   Map<String, String?> _errorMessages = {
//     'username': null,
//     'email': null,
//     'password': null,
//     'confirmPassword': null,
//   };

//   Future<void> _signUp() async {
//     String password = _passwordController.text;
//     String email = _emailController.text;

//     final RegExp emailRegex =
//         RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
//     final RegExp passwordRegex = RegExp(r"^(?=.*[A-Z])(?=.*\d).{8,}$");

//     setState(() {
//       _errorMessages = {
//         'username':
//             _usernameController.text.isEmpty ? 'Name is required' : null,
//         'email': email.isEmpty
//             ? 'Email is required'
//             : (!emailRegex.hasMatch(email) ? 'Invalid email format' : null),
//         'password': password.isEmpty
//             ? 'Password is required'
//             : (!passwordRegex.hasMatch(password)
//                 ? 'Password must be at least 8 characters, include an uppercase letter and a digit'
//                 : null),
//         'confirmPassword': _confirmPasswordController.text.isEmpty
//             ? 'Confirm Password is required'
//             : (_passwordController.text != _confirmPasswordController.text
//                 ? 'Passwords do not match'
//                 : null),
//       };
//     });

//     if (_errorMessages.values.any((msg) => msg != null)) {
//       return; // Stop if there are validation errors
//     }

//     final String url = 'http://127.0.0.1:5000/signup';
//     final Map<String, String> signUpData = {
//       'username': _usernameController.text,
//       'email': email,
//       'password': password,
//     };

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: json.encode(signUpData),
//       );

//       if (response.statusCode == 201) {
//         final responseData = json.decode(response.body);
//         final int userId =
//             int.tryParse(responseData['user_id'].toString()) ?? 0;

//         // Show success SnackBar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Sign up successful! Redirecting...'),
//             backgroundColor: Color.fromARGB(255, 156, 96, 221),
//             behavior: SnackBarBehavior.floating,
//             margin: EdgeInsets.only(top: 50, left: 50, right: 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(24),
//             ),
//           ),
//         );

//         // Navigate to home page with userId
//         Future.delayed(Duration(seconds: 2), () {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   HomeScr(userId: responseData['user_id']), // Pass user_id
//             ),
//           );
//         });
//       } else {
//         _showErrorDialog('Sign-up failed: ${response.body}');
//       }
//     } catch (e) {
//       _showErrorDialog('An error occurred: $e');
//     }
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'SPENDEZ Signup',
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//               ),
//               SizedBox(height: 20),
//               Image.asset('assets/amico.png', height: 200),
//               SizedBox(height: 20),
//               buildTextField(
//                 controller: _usernameController,
//                 label: 'Name',
//                 hintText: 'Enter your Name',
//                 errorMessage: _errorMessages['username'],
//               ),
//               SizedBox(height: 15),
//               buildTextField(
//                 controller: _emailController,
//                 label: 'Email',
//                 hintText: 'Enter your Email',
//                 errorMessage: _errorMessages['email'],
//               ),
//               SizedBox(height: 15),
//               buildPasswordField(
//                 controller: _passwordController,
//                 label: 'Password',
//                 hintText: 'Enter a new password',
//                 errorMessage: _errorMessages['password'],
//               ),
//               SizedBox(height: 15),
//               buildPasswordField(
//                 controller: _confirmPasswordController,
//                 label: 'Confirm Password',
//                 hintText: 'Retype your new password',
//                 errorMessage: _errorMessages['confirmPassword'],
//               ),
//               SizedBox(height: 30),
//               SizedBox(
//                 width: 342,
//                 height: 55,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF7F07FF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24)),
//                   ),
//                   onPressed: _signUp,
//                   child: Text(
//                     'SIGNUP',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     String? errorMessage,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: TextStyle(
//                 fontSize: 16, color: const Color.fromARGB(221, 0, 0, 0))),
//         if (errorMessage != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 5),
//             child: Text(errorMessage,
//                 style: TextStyle(color: Colors.red, fontSize: 14)),
//           ),
//         SizedBox(height: 5),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hintText,
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(24),
//               borderSide: BorderSide(color: Color(0xFFAAA1A1)),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(30),
//               borderSide: BorderSide(color: Color(0xFFAAA1A1), width: 1.5),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildPasswordField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     String? errorMessage,
//   }) {
//     return buildTextField(
//       controller: controller,
//       label: label,
//       hintText: hintText,
//       errorMessage: errorMessage,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:spendez_main/home.dart'; // Import HomeScr
import 'package:spendez_main/shared_pref.dart'; // Import SharedPrefs

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
    String password = _passwordController.text;
    String email = _emailController.text;

    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    final RegExp passwordRegex = RegExp(r"^(?=.*[A-Z])(?=.*\d).{8,}$");

    setState(() {
      _errorMessages = {
        'username':
            _usernameController.text.isEmpty ? 'Name is required' : null,
        'email': email.isEmpty
            ? 'Email is required'
            : (!emailRegex.hasMatch(email) ? 'Invalid email format' : null),
        'password': password.isEmpty
            ? 'Password is required'
            : (!passwordRegex.hasMatch(password)
                ? 'Password must be at least 8 characters, include an uppercase letter and a digit'
                : null),
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

    //final String url = 'http://127.0.0.1:5000/signup';
    final String url = 'http://10.0.2.2:5000/signup';
    final Map<String, String> signUpData = {
      'username': _usernameController.text,
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(signUpData),
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final int userId =
            int.tryParse(responseData['user_id'].toString()) ?? 0;

        // Save login status and user ID
        await SharedPrefs().setLoggedIn(true);
        await SharedPrefs().setUserId(userId);

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up successful! Redirecting...'),
            backgroundColor: Color.fromARGB(255, 156, 96, 221),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(top: 50, left: 50, right: 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        );

        // Navigate to home page with userId
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScr(userId: userId), // Pass user_id
            ),
          );
        });
      } else {
        _showErrorDialog('Sign-up failed: ${response.body}');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
    return buildTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      errorMessage: errorMessage,
    );
  }
}