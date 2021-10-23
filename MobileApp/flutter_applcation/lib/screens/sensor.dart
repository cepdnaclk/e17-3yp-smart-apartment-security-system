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
            leading: Icon(
              Icons.meeting_room_rounded,
              size: 40,
            ),
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
          ListTile(
            leading: Icon(
              Icons.fireplace,
              size: 40,
            ),
            title: Text('Flame Sensor'),
            subtitle: Text('Fire Detecting sensor'),
            //trailing: Icon(Icons.menu),
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (_) => flamesensor(
                        value: value,
                      ));
              Navigator.pushReplacement(context, route);
            },
            onLongPress: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.directions_run_rounded,
              size: 40,
            ),
            title: Text('Motion Sensors'),
            subtitle: Text('Details about motions'),
            // trailing: Icon(Icons.menu),
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (_) => motionsensor(
                        value: value,
                      ));
              Navigator.pushReplacement(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.door_sliding_rounded,
              size: 40,
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
