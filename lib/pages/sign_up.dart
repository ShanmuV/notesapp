import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:notesapp/pages/start_up.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {"email": email, "password": password},
      ),
    );

    if (!mounted) return;

    if (response.statusCode == 200) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return StartUp();
      }));
    } else {
      print("Error " + response.body.toString());
      _errorMessage = "Error Occured.";
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Register",
              style: TextStyle(
                fontFamily: "Satoshi",
                fontSize: 40,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Create an Account for free",
              style: TextStyle(
                fontFamily: "Satoshi",
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextField(
                style: TextStyle(fontFamily: "Satoshi"),
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                    hintText: "Name",
                    hintStyle: TextStyle(fontFamily: "Satoshi"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextField(
                controller: _emailController,
                style: TextStyle(fontFamily: "Satoshi"),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                  hintText: "Email",
                  hintStyle: TextStyle(fontFamily: "Satoshi"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextField(
                controller: _passwordController,
                style: TextStyle(fontFamily: "Satoshi"),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                  hintText: "Password",
                  hintStyle: TextStyle(fontFamily: "Satoshi"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.red),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextButton(
                onPressed: register,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 121, 77, 255),
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: !_isLoading
                    ? Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: "Satoshi",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "Already have an Account? ",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Satoshi",
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: "LogIn",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                    style: TextStyle(
                      fontFamily: "Satoshi",
                      color: Colors.green[400],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
