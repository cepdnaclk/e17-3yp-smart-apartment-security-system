import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/homeSO.dart';
import 'package:http/http.dart' as http;

class sofpsensor extends StatefulWidget {
  late String value;
  sofpsensor({required this.value});
  @override
  State<sofpsensor> createState() => _sofpsensorState(value);
}

class _sofpsensorState extends State<sofpsensor> {
  String value;
  _sofpsensorState(this.value);
  Future<List<Movies>> GetJson() async {
    final data = await http.get(Uri.parse(
        'http://10.0.2.2:3000/user/getaccessfpsensordetails/' + value));
    var JsonData = jsonDecode(data.body);
    List<Movies> items = [];
    for (var m in JsonData) {
      Movies n = Movies(m['houseid']);
      items.add(n);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
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
                    Icon sensor = const Icon(Icons.door_front_door);
                    return ListTile(
                      leading: sensor,
                      title: Text(snapshot.data[index].houseid),
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
  String houseid;
  Movies(this.houseid);
}
