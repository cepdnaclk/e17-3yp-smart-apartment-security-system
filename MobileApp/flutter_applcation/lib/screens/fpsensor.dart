import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/sensor.dart';
import 'package:http/http.dart' as http;

class fpSensors extends StatefulWidget {
  late String value;
  fpSensors({required this.value});
  @override
  State<fpSensors> createState() => _fpSensorsState(value);
}

class _fpSensorsState extends State<fpSensors> {
  String value;
  _fpSensorsState(this.value);
  Future<List<fp>> GetJson() async {
    final data = await http.get(
        Uri.parse('https://10.0.2.2:3000/user/getfpsensordetails/' + value));
    var JsonData = jsonDecode(data.body);
    List<fp> items = [];
    for (var m in JsonData) {
      fp n = fp(m['date'], m['time'], m['username']);
      items.add(n);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fingerprint Access Details"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (_) => sensors(value: value));
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
                    return ListTile(
                      leading: Icon(Icons.fingerprint_rounded),
                      title: Text(
                        snapshot.data[index].username,
                        style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                      ),

                      subtitle: Text(
                        snapshot.data[index].date +
                            " " +
                            snapshot.data[index].time,
                        style: TextStyle(color: Colors.black),
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

class fp {
  String date;
  String time;
  String username;
  fp(this.date, this.time, this.username);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
