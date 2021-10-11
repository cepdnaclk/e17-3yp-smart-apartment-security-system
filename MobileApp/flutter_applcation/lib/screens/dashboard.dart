import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  //final int userId;
  final int id;
  final String name;
  final String email;
  final int phone;
  final String houseid;

  Album(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.houseid});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        name: json['name'],
        id: json['id'],
        email: json['email'],
        phone: json['phone'],
        houseid: json['houseid']);
  }
}

class Dashboard extends StatefulWidget {
  late String value;
  Dashboard({required this.value});

  @override
  _DashboardState createState() => _DashboardState(value);
}

class _DashboardState extends State<Dashboard> {
  late Future<Album> futureAlbum;
  String value;
  _DashboardState(this.value);

  Future<Album> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/user/getdetails/' + value));

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

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.email,
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.name,
                  style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.blueGrey,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          SizedBox(
            height: 10,
          ),
          FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                  snapshot.data!.houseid,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black45,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w300),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        FutureBuilder<Album>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                'Phone Number : ' +
                                    snapshot.data!.phone.toString(),
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }

                            // By default, show a loading spinner.
                            return const CircularProgressIndicator();
                          },
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          "15",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    ));
  }
}
