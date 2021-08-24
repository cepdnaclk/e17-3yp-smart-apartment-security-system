import 'package:flutter/material.dart';
import 'package:tutorial10/form.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return FormTest();
          }));
        },
        child: Text(
          'Sign up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
