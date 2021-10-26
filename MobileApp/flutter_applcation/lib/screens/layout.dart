import 'package:flutter/material.dart';
import 'package:flutter_applcation/screens/Modes.dart';

class ImageScreen extends StatelessWidget {
  late String value;
  ImageScreen({required this.value});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('https://10.0.2.2:3000/images/HN101.jpg'),
                  fit: BoxFit.contain)),
        ),
      ),
    );
  }
}
