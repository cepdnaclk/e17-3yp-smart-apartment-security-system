import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: ImageScreen(value: ,),
      home: MyHomePage(title: 'SAFENET'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    isLogin();
    initPlatformState();
  }

  static const String oneSignalAppId = "b146c005-8195-4098-ac19-0e79fd7b7ae2";

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
  }

  void isLogin() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 5), () {
      if (_sharedPreferences.getInt('userid') == null &&
          _sharedPreferences.getString('usermail') == null) {
        Route route = MaterialPageRoute(builder: (_) => LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => LoginPage());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.grey, Colors.black87],
                  begin: const FractionalOffset(0.0, 1.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.repeated)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.png"),
              ],
            ),
          ),
        ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
