import 'package:flutter/material.dart';
import 'package:tutorial10/signup_button.dart';
import 'Button.dart';
import 'InputField.dart';

class InputWrapper extends StatefulWidget {
  @override
  _InputWrapperState createState() => _InputWrapperState();
}

class _InputWrapperState extends State<InputWrapper> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: InputField(),
          ),
          SizedBox(
            height: 40,
          ),
          Button(),
          Divider(),
          Signup()
        ],
      ),
    );
  }
}
