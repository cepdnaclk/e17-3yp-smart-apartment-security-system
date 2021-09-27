import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/rest/rest_api.dart';
import 'package:flutter_applcation/screens/home_page.dart';
import 'package:flutter_applcation/screens/register_page.dart';
import 'package:flutter_applcation/widgets/form_fields_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SharedPreferences _sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Material(
          child: SingleChildScrollView(
              child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.grey, Colors.black87],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "SAFENET",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Smart Apartment Security System",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
                width: 250,
                height: 250,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormFields(
                      controller: _emailController,
                      data: Icons.email,
                      txtHint: 'Email',
                      obsecure: false,
                    ),
                    FormFields(
                      controller: _passwordController,
                      data: Icons.lock,
                      txtHint: 'Password',
                      obsecure: true,
                    ),
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15,
                ),
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: () {
                    _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                        ? doLogin(
                            _emailController.text, _passwordController.text)
                        : Fluttertoast.showToast(
                            msg: 'All fields are required',
                            textColor: Colors.red);
                  },
                  color: Colors.blue,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RegisterPage()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Register Here",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                ],
              ),
            )
          ],
        ),
      ))),
    );
  }

  doLogin(String email, String password) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var res = await userLogin(email.trim(), password.trim());
    print(res.toString());
    if (res['success']) {
      String userEmail = res['user'][0]['email'];
      int userId = res['user'][0]['id'];
      _sharedPreferences.setInt('userid', userId);
      _sharedPreferences.setString('usermail', userEmail);

      Route route = MaterialPageRoute(builder: (_) => HomePage());
      Navigator.pushReplacement(context, route);
    } else {
      Fluttertoast.showToast(
          msg: 'Email and password not valid ?', textColor: Colors.red);
    }
  }
}
