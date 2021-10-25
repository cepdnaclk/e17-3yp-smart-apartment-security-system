import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/rest/rest_api.dart';
import 'package:flutter_applcation/screens/LoginSO.dart';
import 'package:flutter_applcation/screens/Modes.dart';
import 'package:flutter_applcation/screens/register_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_auth/email_auth.dart';

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
  final TextEditingController _otp = TextEditingController();

  late SharedPreferences _sharedPreferences;
  late String value;
  late EmailAuth emailAuth;
  var otpval;
  @override
  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = EmailAuth(
      sessionName: "Safenet Email verification",
    );
  }

  void verify() {
    // ignore: avoid_print
    otpval = (emailAuth.validateOtp(
        recipientMail: _emailController.value.text, userOtp: _otp.value.text));
    print(otpval);
    if (otpval) {
      Fluttertoast.showToast(msg: 'Email Verified', textColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: 'Email Not Verified', textColor: Colors.red);
    }
  }

  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailController.value.text, otpLength: 5);
    if (result) {
      Fluttertoast.showToast(
          msg: 'OTP sent successfully', textColor: Colors.red);
    } else {
      Fluttertoast.showToast(msg: "OTP could't sent", textColor: Colors.red);
    }
  }

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
                colors: [Colors.blue.shade600, Colors.black87],
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
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "SAFENET",
                      style: GoogleFonts.sarpanch(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      )),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "User Login",
                      style: GoogleFonts.sarpanch(
                          textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                      )),
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Icon(
                Icons.add_moderator,
                size: 200,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(
                          color: Colors.black,
                          height: 2,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            filled: true,
                            fillColor: Colors.white,
                            //border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            suffixIcon: TextButton(
                              child: const Text(
                                'Send OTP',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () => sendOtp(),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _otp,
                        style: TextStyle(
                          color: Colors.black,
                          height: 2,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.notification_add),
                            filled: true,
                            fillColor: Colors.white,
                            //border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            hintText: "Enter OTP",
                            hintStyle: TextStyle(
                              color: Colors.black,
                            ),
                            suffixIcon: TextButton(
                              child: const Text(
                                'Verify Email',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () => verify(),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        controller: _passwordController,
                        style: TextStyle(
                          color: Colors.black,
                          height: 2,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          fillColor: Colors.white,
                          //border: OutlineInputBorder(),
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15,
                ),
                RaisedButton(
                  onPressed: () {
                    _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty //&& otpval
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
                ),
                SizedBox(
                  width: 15,
                ),
                RaisedButton(
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (_) => LoginPageSO());
                    Navigator.pushReplacement(context, route);
                  },
                  color: Colors.blue,
                  child: Text(
                    'Security Officer >>',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
    if (res['success']) {
      print(res['success']);
      String userEmail = res['user'][0]['email'];
      //int userId = res['user'][0]['id'];
      value = userEmail;
      //_sharedPreferences.setInt('userid', userId);
      _sharedPreferences.setString('usermail', userEmail);

      Route route =
          MaterialPageRoute(builder: (_) => SwitchScreen(value: value));
      Navigator.pushReplacement(context, route);
    } else {
      Fluttertoast.showToast(
          msg: 'Email and password not valid ?', textColor: Colors.red);
    }
  }
}
