import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/homenavdrawer.dart';
import 'package:url_launcher/url_launcher.dart';

class Album {
  //final int userId;
  final int phone;

  Album({
    required this.phone,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      phone: json['phone'],
    );
  }
}

class contacts extends StatefulWidget {
  late String value;
  contacts({required this.value});
  @override
  _contactsState createState() => _contactsState(value);
}

class _contactsState extends State<contacts> {
  String value;
  _contactsState(this.value);
  late Future<Album> futureAlbum;

  Future<Album> fetchAlbum() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:3000/user/getso/' + value));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
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
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
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
          FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String phne = snapshot.data!.phone.toString();
                  return ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Security Officer'),
                    subtitle: Text(phne),
                    //trailing: Icon(Icons.menu),
                    onTap: () {
                      setState(() {
                        _launched = _makePhoneCall('tel:$phne');
                      });
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.fireplace),
            title: Text('Emergency Number'),
            subtitle: Text('119'),
            //trailing: Icon(Icons.menu),
            onTap: () {
              _phone = '119';
              setState(() {
                _launched = _makePhoneCall('tel:$_phone');
              });
            },
            onLongPress: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_police),
            title: Text('Sri Lanka Police'),
            subtitle: Text('0112222222'),
            // trailing: Icon(Icons.menu),
            onTap: () {
              _phone = '0112222222';
              setState(() {
                _launched = _makePhoneCall('tel:$_phone');
              });
            },
          ),
        ],
      ),
    );
  }
}
