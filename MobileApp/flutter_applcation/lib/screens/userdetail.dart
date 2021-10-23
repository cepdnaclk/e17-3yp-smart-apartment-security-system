import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_applcation/screens/Modes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Album {
  //final int userId;
  //final int id;
  final String name;
  final String email;
  final int phone;
  final String houseid;

  Album(
      { //required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.houseid});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        name: json['name'],
        //id: json['id'],
        email: json['email'],
        phone: json['phone'],
        houseid: json['houseid']);
  }
}

class UserDetails extends StatefulWidget {
  late String value;
  UserDetails({required this.value});

  @override
  _UserDetailsState createState() => _UserDetailsState(value);
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController houseid = TextEditingController();

  late Future<Album> futureAlbum;
  String value;
  _UserDetailsState(this.value);

  var namestring, houseidstring, phoneno;

  Future<Album> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://10.0.2.2:3000/user/getdetails/' + value));

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

  Future userUpdate(String name, String phone, String houseid) async {
    final response = await http.post(
        Uri.parse("https://10.0.2.2:3000/user/updateuserdetails/" + value),
        headers: {"Accept": "Application/json"},
        body: {'name': name, 'phone': phone, 'houseid': houseid});

    var decodeData = jsonDecode(response.body);
    return decodeData;
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
                  Route route = MaterialPageRoute(
                      builder: (_) => SwitchScreen(value: value));
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
                        Icons.person,
                        size: 80,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.blue.withOpacity(0.4))
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
              Form(
                  child: Column(
                children: [
                  buildTextField1("Full Name", false),
                  //buildTextField2("User ID", false),
                  buildTextField3("Phone Number", false),
                  buildTextField4("House ID", false),
                ],
              )),
              ElevatedButton(
                onPressed: () {
                  if (name.text == '') {
                    name.text = namestring;
                  }
                  if (phone.text == '') {
                    phone.text = phoneno;
                  }
                  if (houseid.text == '') {
                    houseid.text = houseidstring;
                  }
                  userUpdate(name.text, phone.text, houseid.text);
                  Fluttertoast.showToast(
                      msg: 'Successfully updated', textColor: Colors.red);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserDetails(value: value)));
                },
                child: const Text(
                  "UPDATE DETAILS",
                  style: TextStyle(
                      fontSize: 15, letterSpacing: 2, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              )
            ],
          ),
        ));
  }

  Widget buildTextField1(String labelText, bool isPasswordTextField) {
    var isObscurePassword = true;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(children: [
        FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              namestring = snapshot.data!.name;
              return TextFormField(
                controller: name,
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
                    hintText: snapshot.data!.name,
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
/*
  Widget buildTextField2(String labelText, bool isPasswordTextField) {
    var isObscurePassword = true;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(children: [
        FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TextFormField(
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

  Widget buildTextField3(String labelText, bool isPasswordTextField) {
    var isObscurePassword = true;
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: Column(children: [
        FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              phoneno = snapshot.data!.phone.toString();
              return TextFormField(
                controller: phone,
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
                    hintText: snapshot.data!.phone.toString(),
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
        FutureBuilder<Album>(
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              houseidstring = snapshot.data!.houseid;
              return TextFormField(
                controller: houseid,
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
                    hintText: snapshot.data!.houseid,
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
