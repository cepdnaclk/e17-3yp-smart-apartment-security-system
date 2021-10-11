import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/homenavdrawer.dart';
import 'package:flutter_applcation/screens/motionsensor.dart';
import 'package:flutter_applcation/screens/windowsensors.dart';

class sensors extends StatefulWidget {
  late String value;
  sensors({required this.value});
  @override
  _sensorsState createState() => _sensorsState(value);
}

class _sensorsState extends State<sensors> {
  String value;
  _sensorsState(this.value);
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
                Route route =
                    MaterialPageRoute(builder: (_) => DrawerPage(value: value));
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
            leading: Icon(Icons.doorbell),
            title: Text('Front Door'),
            subtitle: Text('Details of Front Door'),
            //trailing: Icon(Icons.menu),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.fireplace),
            title: Text('Flame Sensor'),
            subtitle: Text('Fire Detecting sensor'),
            //trailing: Icon(Icons.menu),
            onTap: () {},
            onLongPress: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.downhill_skiing),
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
            leading: Icon(Icons.window),
            title: Text('Window Sensors'),
            subtitle: Text('Change the Image'),
            // trailing: Icon(Icons.menu),
            onTap: () {
              Route route = MaterialPageRoute(
                  builder: (_) => windowsensor(
                        value: value,
                      ));
              Navigator.pushReplacement(context, route);
            },
          ),
        ],
      ),
    );
  }
}
