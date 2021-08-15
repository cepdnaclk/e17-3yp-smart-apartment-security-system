import 'package:flutter/material.dart';
import 'package:tutorial10/Sensor.dart';
import 'package:tutorial10/signup_button.dart';
import 'Home.dart';
import 'LoginPage.dart';
import 'Mode.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(debugShowCheckedModeBanner: false, home: sensors());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage(String s);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Tutorial 10"),
      ),
    );
  }
}
