import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/homeSO.dart';
import 'package:http/http.dart' as http;

class soSensors extends StatefulWidget {
  late String value;
  soSensors({required this.value});
  @override
  State<soSensors> createState() => _soSensorsState(value);
}

class _soSensorsState extends State<soSensors> {
  String value;
  late Color color;
  _soSensorsState(this.value);
  Future<List<Movies>> GetJson() async {
    final data = await http.get(
        Uri.parse('http://10.0.2.2:3000/user/getallsensordetails/' + value));
    var JsonData = jsonDecode(data.body);
    List<Movies> items = [];
    for (var m in JsonData) {
      Movies n = Movies(m['type'], m['status'], m['houseid']);
      items.add(n);
    }
    return items;
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
                Route route =
                    MaterialPageRoute(builder: (_) => sohome(value: value));
                Navigator.pushReplacement(context, route);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: GetJson(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: const Center(
                  child: Text("Loading...."),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (snapshot.data[index].status == 'active') {
                      color = Colors.red;
                    } else {
                      color = Colors.blue;
                    }
                    Icon sensor = const Icon(Icons.window);
                    if (snapshot.data[index].type == 'window sensor') {
                      sensor = const Icon(Icons.window);
                    } else if (snapshot.data[index].type == 'motion sensor') {
                      sensor = const Icon(Icons.motion_photos_auto);
                    } else if (snapshot.data[index].type == 'flame sensor') {
                      sensor = const Icon(Icons.fireplace);
                    }

                    return ListTile(
                      leading: sensor,
                      title: Text(
                        snapshot.data[index].houseid,
                        style: TextStyle(color: color, fontSize: 18),
                      ),

                      subtitle: Text(
                        snapshot.data[index].status,
                        style: TextStyle(color: color),
                      ),
                      //isThreeLine: true,
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}

class Movies {
  String type;
  String status;
  String houseid;
  Movies(this.type, this.status, this.houseid);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
