import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_applcation/screens/Modes.dart';
import 'package:flutter_applcation/screens/login_page.dart';
import 'package:flutter_applcation/screens/sensor.dart';
import 'package:flutter_applcation/screens/windowsensors.dart';
import 'package:flutter_applcation/screens/userdetail.dart';

import '../main.dart';

// ignore: must_be_immutable
class DrawerPage extends StatefulWidget {
  late String value;
  DrawerPage({required this.value});

  @override
  _DrawerPageState createState() => _DrawerPageState(value);
}

class _DrawerPageState extends State<DrawerPage> {
  String value;
  _DrawerPageState(this.value);
  var currentPage = DrawerSections.Modes;

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.UserDetails) {
      container = UserDetails(
        value: value,
      );
    } else if (currentPage == DrawerSections.Modes) {
      container = SwitchScreen(
        value: value,
      );
    } else if (currentPage == DrawerSections.events) {
      container = sensors(
        value: value,
      );
    } else if (currentPage == DrawerSections.settings) {
      container = windowsensor(
        value: value,
      );
    } else if (currentPage == DrawerSections.logout) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => LoginPage()));
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text(value),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  color: Colors.blue[700],
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.only(top: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 70,
                        child: CircleAvatar(
                          minRadius: 4,
                          child: Icon(
                            Icons.person,
                            size: 40,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text(
                        "SAFENET",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(
              1,
              "Details",
              Icons.home,
              currentPage == DrawerSections.dashboard ? true : false,
              Colors.deepPurple),
          menuItem(2, "Modes", Icons.mode,
              currentPage == DrawerSections.Modes ? true : false, Colors.pink),
          menuItem(3, "Sensors", Icons.sensor_door,
              currentPage == DrawerSections.events ? true : false, Colors.blue),
          menuItem(4, "Layout", Icons.layers_outlined,
              currentPage == DrawerSections.notes ? true : false, Colors.red),
          Divider(),
          menuItem(
              5,
              "Notifications",
              Icons.settings_outlined,
              currentPage == DrawerSections.settings ? true : false,
              Colors.blue),
          menuItem(6, "Logout", Icons.layers_outlined,
              currentPage == DrawerSections.notes ? true : false, Colors.red),
        ],
      ),
    );
  }

  Widget menuItem(
      int id, String title, IconData icon, bool selected, Color color) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.UserDetails;
            } else if (id == 2) {
              currentPage = DrawerSections.Modes;
            } else if (id == 3) {
              currentPage = DrawerSections.events;
            } else if (id == 4) {
              currentPage = DrawerSections.notes;
            } else if (id == 5) {
              currentPage = DrawerSections.settings;
            } else if (id == 6) {
              currentPage = DrawerSections.logout;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  UserDetails,
  dashboard,
  Modes,
  events,
  notes,
  settings,
  logout,
}
