import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notesapp/pages/home_page.dart';
import 'package:notesapp/pages/sign_up.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _authenticate() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    final email = _emailController.text;
    print("Request Made: Email: $email");

    final response = await http.post(Uri.parse("http://10.0.2.2:8000/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _emailController.text,
          "password": _passwordController.text
        }));
    if (!mounted) return;

    try {
      if (response.statusCode == 200) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        throw "Invalid Username or Password";
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              "Login",
              style: TextStyle(fontFamily: "Satoshi", fontSize: 40),
            ),
            SizedBox(height: 10),
            Text(
              "Welcome Back",
              style: TextStyle(
                fontFamily: "Satoshi",
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextField(
                controller: _emailController,
                style: TextStyle(fontFamily: "Satoshi"),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                  hintText: "Email",
                  hintStyle: TextStyle(
                    fontFamily: "Satoshi",
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  enabledBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.zero),
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextField(
                controller: _passwordController,
                style: TextStyle(fontFamily: "Satoshi"),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                  hintText: "Password",
                  hintStyle: TextStyle(fontFamily: "Satoshi"),
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                  focusedBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.zero),
                  enabledBorder:
                      OutlineInputBorder(borderRadius: BorderRadius.zero),
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
              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: TextButton(
                onPressed: _isLoading ? null : _authenticate,
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 121, 77, 255),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: !_isLoading
                    ? Text(
                        "Log In",
                        style: TextStyle(
                          fontFamily: "Satoshi",
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                text: "Don't have and Account? ",
                style: TextStyle(
                  fontFamily: "Satoshi",
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: "Register",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                    style: TextStyle(
                      fontFamily: "Satoshi",
                      fontWeight: FontWeight.w600,
                      color: Colors.green[400],
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
