import 'package:flutter/material.dart';

class sensors extends StatefulWidget {
  @override
  _sensorsState createState() => _sensorsState();
}

class _sensorsState extends State<sensors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor Details"),
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
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.window),
            title: Text('Window Sensors'),
            subtitle: Text('Change the Image'),
            // trailing: Icon(Icons.menu),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
