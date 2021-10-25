import 'dart:convert';
import 'package:flutter_applcation/screens/Modes.dart';
import 'package:flutter_applcation/screens/fpsensor.dart';
import 'package:flutter_applcation/screens/windowsensor2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/flamesensor.dart';
import 'package:flutter_applcation/screens/motionsensor.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';

class sensor {
  //final int userId;
  //final int id;
  final String uniqueid;
  final String type;
  final String status;

  sensor(
      { //required this.id,
      required this.uniqueid,
      required this.type,
      required this.status});

  factory sensor.fromJson(Map<String, dynamic> json) {
    return sensor(
        //id: json['id'],
        uniqueid: json['uniqueid'],
        type: json['type'],
        status: json['status']);
  }
}

class sensors extends StatefulWidget {
  late String value;
  sensors({required this.value});
  @override
  _sensorsState createState() => _sensorsState(value);
}

class _sensorsState extends State<sensors> {
  String value;
  bool status1 = true;
  bool status2 = false;
  String statuschange = 'active';
  String statuschange2 = 'false';
  _sensorsState(this.value);

  late Future<sensor> futureAlbum;
  late Future<sensor> futureAlbum2;

  Future<sensor> fetchAlbum() async {
    final response = await http.get(
        Uri.parse('https://10.0.2.2:3000/user/getflamesensordetails/' + value));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return sensor.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<sensor> fetchAlbum2() async {
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:3000/user/getmotionsensordetails/' + value));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return sensor.fromJson(jsonDecode(response.body));
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
    futureAlbum2 = fetchAlbum2();
  }

  Future updatemode(String status) async {
    final response = await http.post(
        Uri.parse("https://10.0.2.2:3000/user/updatemodesensor/" + value),
        headers: {
          "Accept": "Application/json"
        },
        body: {
          'status': status,
        });

    var decodeData = jsonDecode(response.body);
    return decodeData;
  }

  Future updateaccessSO(String status) async {
    final response = await http.post(
        Uri.parse("https://10.0.2.2:3000/user/updatesoaccess/" + value),
        headers: {
          "Accept": "Application/json"
        },
        body: {
          'status': status,
        });

    var decodeData = jsonDecode(response.body);
    return decodeData;
  }

  doupdate(String status) async {
    var res = await updatemode(status);
    if (res['success']) {
      Fluttertoast.showToast(
          msg: 'Successfully updated', textColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: 'Try again', textColor: Colors.red);
    }
  }

  doupdate2(String status) async {
    var res = await updateaccessSO(status);
    if (res['success']) {
      Fluttertoast.showToast(
          msg: 'Successfully updated', textColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: 'Try again', textColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor Details"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Route route = MaterialPageRoute(
                    builder: (_) => SwitchScreen(value: value));
                Navigator.pushReplacement(context, route);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          ListTile(
            leading:
                Icon(Icons.meeting_room_rounded, size: 40, color: Colors.brown),
            title: Text('Front Door'),
            subtitle: Text('Details of Front Door'),
            //trailing: Icon(Icons.menu),
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (_) => fpSensors(
                        value: value,
                      ));
              Navigator.pushReplacement(context, route);
            },
          ),
          Divider(),
          FutureBuilder<sensor>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: Icon(
                      Icons.fireplace,
                      size: 40,
                      color: Colors.red.shade900,
                    ),
                    title: Text('Flame Sensor'),
                    subtitle: Text(
                      'Status : ' + snapshot.data!.status,
                      style: TextStyle(color: Colors.red.shade800),
                    ),
                    //trailing: Icon(Icons.menu),
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (_) => flamesensor(
                                value: value,
                              ));
                      Navigator.pushReplacement(context, route);
                    },
                    onLongPress: () {},
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              }),
          Divider(),
          FutureBuilder<sensor>(
              future: futureAlbum2,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    leading: Icon(
                      Icons.directions_run_rounded,
                      size: 40,
                      color: Colors.amber,
                    ),
                    title: Text('Motion Sensors'),
                    subtitle: Text(
                      'Status :' + snapshot.data!.status,
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                    //trailing: Icon(Icons.menu),
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (_) => motionsensor(
                                value: value,
                              ));
                      Navigator.pushReplacement(context, route);
                    },
                    onLongPress: () {},
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              }),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.door_sliding_rounded,
              size: 40,
              color: Colors.teal.shade600,
            ),
            title: Text('Window Sensors'),
            subtitle: Text('Change the Image'),
            // trailing: Icon(Icons.menu),
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (_) => windowsensor2(
                        value: value,
                      ));
              Navigator.pushReplacement(context, route);
            },
          ),
          Divider(),
          SizedBox(height: 40.0),
          Center(
            child: Text(
              "Change the status of all sensors",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              FlutterSwitch(
                showOnOff: true,
                activeTextColor: Colors.black,
                inactiveTextColor: Colors.blue.shade50,
                value: status1,
                onToggle: (val) {
                  setState(() {
                    status1 = val;
                    if (val) {
                      statuschange = 'active';
                    } else {
                      statuschange = 'deactive';
                    }
                    doupdate(statuschange);
                  });
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "Status: $statuschange",
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 40.0),
          Center(
            child: Text(
              "Give access SO to enter the house",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              FlutterSwitch(
                showOnOff: true,
                activeTextColor: Colors.black,
                inactiveTextColor: Colors.blue.shade50,
                value: status2,
                onToggle: (val) {
                  setState(() {
                    status2 = val;
                    if (val) {
                      statuschange2 = 'true';
                    } else {
                      statuschange2 = 'false';
                    }
                    doupdate2(statuschange2);
                  });
                },
              ),
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "Status: $statuschange2",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
