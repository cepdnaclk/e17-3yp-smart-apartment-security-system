import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'homenavdrawer.dart';

class SwitchScreen extends StatefulWidget {
  late String value;
  SwitchScreen({required this.value});

  @override
  _SwitchScreenState createState() => _SwitchScreenState(value);
}

class _SwitchScreenState extends State<SwitchScreen> {
  String value;

  _SwitchScreenState(this.value);

  bool status7 = false;

  bool isSwitchOn = false;

  Color _textColor = Colors.black;
  Color _appBarColor = Colors.green;
  Color _scaffoldBgcolor = Colors.blueAccent;
  String modes = 'Home';
  Future updatemode(String mode) async {
    final response = await http.post(
        Uri.parse("http://10.0.2.2:3000/user/updatemode/" + value),
        headers: {
          "Accept": "Application/json"
        },
        body: {
          'mode': mode,
        });

    var decodeData = jsonDecode(response.body);
    return decodeData;
  }

  doupdate(String mode) async {
    var res = await updatemode(mode);
    if (res['success']) {
      Fluttertoast.showToast(
          msg: 'Successfully updated', textColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: 'Try again', textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(color: _textColor),
          bodyText2: TextStyle(color: _textColor),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _scaffoldBgcolor,
          title: Text("$modes Mode Activated"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.health_and_safety_sharp),
                iconSize: 120,
                onPressed: () {
                  Route route = MaterialPageRoute(
                      builder: (_) => DrawerPage(value: value));
                  Navigator.pushReplacement(context, route);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          leadingWidth: 120,
          toolbarHeight: 140,
        ),
        backgroundColor: Colors.white54,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: EdgeInsets.all(60),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Select the Mode",
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 10,
                ),
                FlutterSwitch(
                  width: 130.0,
                  height: 75.0,
                  toggleSize: 60.0,
                  value: status7,
                  borderRadius: 50.0,
                  padding: 3.0,
                  activeToggleColor: Color(0xFF6E40C9),
                  inactiveToggleColor: Color(0xFF2F363D),
                  activeSwitchBorder: Border.all(
                    color: Colors.greenAccent,
                    width: 6.0,
                  ),
                  inactiveSwitchBorder: Border.all(
                    color: Colors.blue,
                    width: 6.0,
                  ),
                  activeColor: Colors.green,
                  inactiveColor: Colors.white,
                  activeIcon: Icon(
                    Icons.run_circle,
                    color: Color(0xFFF8E3A1),
                  ),
                  inactiveIcon: Icon(
                    Icons.home,
                    color: Color(0xFFFFDF5D),
                  ),
                  onToggle: (val) {
                    setState(() {
                      status7 = val;
                      doupdate(status7.toString());

                      if (val) {
                        modes = 'Away';
                        _textColor = Colors.white;
                        _appBarColor = Color.fromRGBO(22, 27, 34, 1);
                        _scaffoldBgcolor = Colors.green;
                      } else {
                        modes = 'Home';
                        _textColor = Colors.black;
                        _appBarColor = Color.fromRGBO(36, 41, 46, 1);
                        _scaffoldBgcolor = Colors.blue;
                      }
                    });
                  },
                ),
              ],

              //----------------------------------------------------------------------------
            ),
          ),
        ),
      ),
    );
  }
}