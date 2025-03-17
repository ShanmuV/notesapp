import 'package:flutter/material.dart';
import 'package:notesapp/pages/home_page.dart';
import 'package:notesapp/pages/start_up.dart';
import 'package:notesapp/pages/upload_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const StartUp(),
        theme: ThemeData(
          fontFamily: "Satoshi",
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(125, 91, 237, 1),
          ),
          textTheme: TextTheme(
            headlineSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            bodyLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            bodyMedium: TextStyle(),
          ),
        ));
  }
}
