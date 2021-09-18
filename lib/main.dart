import 'package:flutter/material.dart';
import 'package:pyserve/pages/home.dart';

void main() {
  runApp(MyApp(

  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black
      ),
      home: HomePage()
    );
  }
}
