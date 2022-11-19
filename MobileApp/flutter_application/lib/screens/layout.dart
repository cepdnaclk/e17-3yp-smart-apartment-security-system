import 'package:flutter/material.dart';
import 'package:flutter_application/screens/Modes.dart';

// ignore: must_be_immutable
class ImageScreen extends StatelessWidget {
  String url =
      'https://drive.google.com/file/d/16PlyFrzfKy9qtaj7x7I1uF5R84SuFEu6/view?usp=sharing';
  late String value;
  ImageScreen({required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Layout of the house',
          ),
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.navigate_before),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image(
                  image: AssetImage('assets/images/HN101.png'),
                )),
          ],
        ));
  }
}
