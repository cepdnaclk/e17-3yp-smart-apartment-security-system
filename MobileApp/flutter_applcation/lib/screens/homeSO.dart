import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_applcation/screens/login_page.dart';
import 'package:flutter_applcation/screens/soSensors.dart';
import 'package:flutter_applcation/screens/soUsers.dart';
import 'package:flutter_applcation/screens/sofpsensor.dart';

class sohome extends StatefulWidget {
  late String value;
  sohome({required this.value});
  @override
  _sohomeState createState() => _sohomeState(value);
}

class _sohomeState extends State<sohome> {
  String value;
  _sohomeState(this.value);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Portal of Security Officer"),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.person,
              size: 40,
              color: Colors.purpleAccent,
            ),
            title: Text('House Owners'),
            subtitle: Text('Contacts of the House Owners'),
            //trailing: Icon(Icons.menu),
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (_) => soUsers(value: value));
              Navigator.pushReplacement(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.sensor_window_rounded,
              size: 40,
              color: Colors.indigoAccent,
            ),
            title: Text('Sensors'),
            subtitle: Text('Activation details about sensors'),
            //trailing: Icon(Icons.menu),
            onTap: () {
              Route route =
                  MaterialPageRoute(builder: (_) => soSensors(value: value));
              Navigator.pushReplacement(context, route);
            },
            onLongPress: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.sensor_door,
              size: 40,
              color: Colors.purpleAccent,
            ),
            title: Text('Front Door Sensors'),
            subtitle: Text('The frontdoors that Security Officer can access'),
            // trailing: Icon(Icons.menu),
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (_) => sofpsensor(
                        value: value,
                      ));
              Navigator.pushReplacement(context, route);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 40,
              color: Colors.indigoAccent,
            ),
            title: Text('Logout'),
            //subtitle: Text('Activation Details about front doors'),
            // trailing: Icon(Icons.menu),
            onTap: () {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => LoginPage()));
              });
            },
          ),
        ],
      ),
    );
  }
}
