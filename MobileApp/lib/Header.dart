import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "SAFENET",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              "Smart Apartment Security System",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}
