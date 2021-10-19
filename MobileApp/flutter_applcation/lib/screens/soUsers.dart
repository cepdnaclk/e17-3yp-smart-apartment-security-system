import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/homeSO.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class soUsers extends StatefulWidget {
  late String value;
  soUsers({required this.value});
  @override
  State<soUsers> createState() => _soUsersState(value);
}

class _soUsersState extends State<soUsers> {
  String value;
  _soUsersState(this.value);
  Future<List<Movies>> GetJson() async {
    final data = await http.get(
        Uri.parse('https://10.0.2.2:3000/user/getalluserdetails/' + value));
    var JsonData = jsonDecode(data.body);
    List<Movies> items = [];
    for (var m in JsonData) {
      Movies n = Movies(m['name'], m['phone'], m['houseid']);
      items.add(n);
    }
    return items;
  }

  Future<void>? _launched;
  String _phone = '';

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
                    Icon sensor = const Icon(Icons.person);
                    return ListTile(
                      onTap: () {
                        _phone = snapshot.data[index].phone.toString();
                        setState(() {
                          _launched = _makePhoneCall('tel:$_phone');
                        });
                      },
                      leading: sensor,
                      title: Text(snapshot.data[index].houseid),
                      subtitle: Text(snapshot.data[index].name +
                          "     phone No : " +
                          snapshot.data[index].phone.toString()),
                      isThreeLine: true,
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
  String name;
  int phone;
  String houseid;
  Movies(this.name, this.phone, this.houseid);
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
