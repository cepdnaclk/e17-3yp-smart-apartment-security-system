import 'package:flutter/material.dart';

class Mode extends StatefulWidget {
  @override
  _ModeState createState() => _ModeState();
}

class _ModeState extends State<Mode> {
  int selected = 0;

  Widget customRadio(String text, int index) {
    return OutlineButton(
      onPressed: () {
        setState(() {
          selected = index;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: (selected == index) ? Colors.redAccent : Colors.blueGrey,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      borderSide: BorderSide(
        color: (selected == index) ? Colors.redAccent : Colors.blueGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MODE SELECTION'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customRadio('Stay Mode', 1),
              customRadio('Away Mode', 2),
            ],
          ),
        ),
        //backgroundColor: Colors.blueGrey,
      ),
    );
  }
}
