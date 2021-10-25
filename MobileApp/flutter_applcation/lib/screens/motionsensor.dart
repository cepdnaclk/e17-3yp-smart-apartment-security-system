import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/sensor.dart';
import 'package:http/http.dart' as http;

class sensor {
  //final int userId;
  //final int id;
  final String uniqueid;
  final String type;
  final String status;

  sensor(
      { //required this.id,
      required this.uniqueid,
      required this.type,
      required this.status});

  factory sensor.fromJson(Map<String, dynamic> json) {
    return sensor(
        //id: json['id'],
        uniqueid: json['uniqueid'],
        type: json['type'],
        status: json['status']);
  }
}

class motionsensor extends StatefulWidget {
  late String value;
  motionsensor({required this.value});
  @override
  _motionsensorState createState() => _motionsensorState(value);
}

class _motionsensorState extends State<motionsensor> {
  late Future<sensor> futureAlbum;
  String value;
  _motionsensorState(this.value);

  Future<sensor> fetchAlbum() async {
    final response = await http.get(Uri.parse(
        'https://10.0.2.2:3000/user/getmotionsensordetails/' + value));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return sensor.fromJson(jsonDecode(response.body));
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
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
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
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      child: Icon(
                        Icons.accessibility_new_rounded,
                        size: 80,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.blue.withOpacity(0.6))
                        ],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //buildTextField1("ID", false),
              buildTextField2("Unique ID", false),
              buildTextField3("Type", false),
              buildTextField4("Status", false),
            ],
          ),
        ));
  }

/*
  Widget buildTextField1(String labelText, bool isPasswordTextField) {
    var isObscurePassword = true;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(children: [
        FutureBuilder<sensor>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TextField(
                obscureText: isPasswordTextField ? isObscurePassword : false,
                decoration: InputDecoration(
                    suffixIcon: isPasswordTextField
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ))
                        : null,
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: labelText,
                    labelStyle: TextStyle(fontSize: 20),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: snapshot.data!.id.toString(),
                    hintStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ]),
    );
  }
*/
  Widget buildTextField2(String labelText, bool isPasswordTextField) {
    var isObscurePassword = true;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(children: [
        FutureBuilder<sensor>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TextField(
                obscureText: isPasswordTextField ? isObscurePassword : false,
                decoration: InputDecoration(
                    suffixIcon: isPasswordTextField
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ))
                        : null,
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: labelText,
                    labelStyle: TextStyle(fontSize: 20),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: snapshot.data!.uniqueid,
                    hintStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ]),
    );
  }

  Widget buildTextField3(String labelText, bool isPasswordTextField) {
    var isObscurePassword = true;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(children: [
        FutureBuilder<sensor>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TextField(
                obscureText: isPasswordTextField ? isObscurePassword : false,
                decoration: InputDecoration(
                    suffixIcon: isPasswordTextField
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ))
                        : null,
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: labelText,
                    labelStyle: TextStyle(fontSize: 20),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: snapshot.data!.type,
                    hintStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ]),
    );
  }

  Widget buildTextField4(String labelText, bool isPasswordTextField) {
    var isObscurePassword = true;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(children: [
        FutureBuilder<sensor>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TextField(
                obscureText: isPasswordTextField ? isObscurePassword : false,
                decoration: InputDecoration(
                    suffixIcon: isPasswordTextField
                        ? IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.remove_red_eye,
                              color: Colors.grey,
                            ))
                        : null,
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: labelText,
                    labelStyle: TextStyle(fontSize: 20),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: snapshot.data!.status,
                    hintStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey)),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ]),
    );
  }
}
