import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application/screens/contacts.dart';
import 'package:flutter_application/screens/layout.dart';
import 'package:flutter_application/screens/notification.dart';
import 'package:flutter_application/screens/sensor.dart';
import 'package:flutter_application/screens/userdetail.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'login_page.dart';

class modeofhouse {
  final String mode_house;

  modeofhouse({required this.mode_house});

  factory modeofhouse.fromJson(Map<String, dynamic> json) {
    return modeofhouse(
        //id: json['id'],
        mode_house: json['mode']);
  }
}

class SwitchScreen extends StatefulWidget {
  late String value;
  SwitchScreen({required this.value});

  @override
  _SwitchScreenState createState() => _SwitchScreenState(value);
}

class _SwitchScreenState extends State<SwitchScreen> {
  String value;
  late Future<modeofhouse> futureAlbum;
  _SwitchScreenState(this.value);
  Future<modeofhouse> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:3000/user/getsensordetails/' + value));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return modeofhouse.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    print(futureAlbum);
  }

  bool status7 = false;

  bool isSwitchOn = false;

  Color _textColor = Colors.black;
  Color _appBarColor = Colors.green;
  Color _scaffoldBgcolor = Colors.blueAccent;

  String modes = 'Home';
  Future updatemode(String mode) async {
    final response = await http.post(
        Uri.parse("https://10.0.2.2:3000/user/updatemode/" + value),
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
                icon: const Icon(Icons.security_sharp),
                iconSize: 90,
                onPressed: () {},
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          leadingWidth: 100,
          toolbarHeight: 110,
        ),
        backgroundColor: Colors.white54,
        body: Column(children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            margin: const EdgeInsets.all(50),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const Text(
                  "Select the Mode",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 10,
                ),
                FlutterSwitch(
                  width: 110.0,
                  height: 65.0,
                  toggleSize: 60.0,
                  value: status7,
                  borderRadius: 50.0,
                  padding: 3.0,
                  activeToggleColor: Colors.green.shade700,
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
                  activeIcon: const Icon(
                    Icons.light_mode_rounded,
                    color: Color(0xFFF8E3A1),
                  ),
                  inactiveIcon: const Icon(
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
                        _appBarColor = const Color.fromRGBO(22, 27, 34, 1);
                        _scaffoldBgcolor = Colors.green;
                      } else {
                        modes = 'Home';
                        _textColor = Colors.black;
                        _appBarColor = const Color.fromRGBO(36, 41, 46, 1);
                        _scaffoldBgcolor = Colors.blue;
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (_) => UserDetails(
                                        value: value,
                                      ));
                              Navigator.pushReplacement(context, route);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(_scaffoldBgcolor),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                            ),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: const <Widget>[
                                Icon(Icons.person),
                                Text("User")
                              ],
                            ))),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (_) => sensors(
                                        value: value,
                                      ));
                              Navigator.pushReplacement(context, route);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(_scaffoldBgcolor),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                            ),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: const <Widget>[
                                Icon(Icons.sensors_sharp),
                                Text("Sensors")
                              ],
                            ))),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (_) => ImageScreen(
                                        value: value,
                                      ));
                              Navigator.pushReplacement(context, route);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(_scaffoldBgcolor),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                            ),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: const <Widget>[
                                Icon(Icons.layers_outlined),
                                Text("Layout")
                              ],
                            ))),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (_) => notification());
                              Navigator.pushReplacement(context, route);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(_scaffoldBgcolor),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                            ),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: const <Widget>[
                                Icon(Icons.account_circle_rounded),
                                Text(
                                  "About Us",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ))),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Route route = MaterialPageRoute(
                                  builder: (_) => contacts(
                                        value: value,
                                      ));
                              Navigator.pushReplacement(context, route);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(_scaffoldBgcolor),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(10)),
                            ),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: const <Widget>[
                                Icon(Icons.add_ic_call_rounded),
                                Text("Contacts")
                              ],
                            ))),
                    const SizedBox(
                      width: 25,
                    ),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () => {
                                  SchedulerBinding.instance!
                                      .addPostFrameCallback((_) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  })
                                },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(_scaffoldBgcolor),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                            ),
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: const <Widget>[
                                Icon(Icons.logout),
                                Text("Logout")
                              ],
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
