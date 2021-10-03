import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applcation/rest/rest_api.dart';
import 'package:flutter_applcation/screens/login_page.dart';
import 'package:flutter_applcation/widgets/form_fields_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController houseid = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final heightOfScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Colors.grey, Colors.black87],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated)),
        height: heightOfScreen,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Container(),
              top: MediaQuery.of(context).size.height * .15,
              right: MediaQuery.of(context).size.height * .4,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                    ),
                    titleWidget(),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            FormFields(
                              controller: username,
                              data: Icons.person,
                              txtHint: 'Username',
                              obsecure: false,
                            ),
                            FormFields(
                              controller: email,
                              data: Icons.email,
                              txtHint: 'Email',
                              obsecure: false,
                            ),
                            FormFields(
                              controller: phone,
                              data: Icons.phone,
                              txtHint: 'Mobile No',
                              obsecure: false,
                            ),
                            FormFields(
                              controller: houseid,
                              data: Icons.house,
                              txtHint: 'House ID',
                              obsecure: false,
                            ),
                            FormFields(
                              controller: password,
                              data: Icons.lock,
                              txtHint: 'Password',
                              obsecure: true,
                            ),
                            FormFields(
                              controller: confirmpassword,
                              data: Icons.lock,
                              txtHint: 'Confirm Password',
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
                        // ignore: deprecated_member_use
                        RaisedButton(
                          onPressed: () {
                            if (username.text.isNotEmpty &&
                                password.text.isNotEmpty &&
                                phone.text.isNotEmpty &&
                                houseid.text.isNotEmpty &&
                                confirmpassword.text.isNotEmpty &&
                                email.text.isNotEmpty) {
                              if (password.text == confirmpassword.text) {
                                doRegister(username.text, email.text,
                                    password.text, phone.text, houseid.text);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Recheck the passwords',
                                    textColor: Colors.red);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'All fields are required',
                                  textColor: Colors.red);
                            }
                          },
                          color: Colors.blue,
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    _LoginText(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }

  titleWidget() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'SAFE',
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
              fontWeight: FontWeight.w700,
            ),
            children: [
              TextSpan(
                  text: 'NET',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      fontSize: 30)),
            ]));
  }

  doRegister(String username, String email, String password, String phoneno,
      String houseid) async {
    var res = await userRegister(username, email, password, phoneno, houseid);
    if (res['success']) {
      Fluttertoast.showToast(
          msg: 'Successfully Registered', textColor: Colors.red);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
        Fluttertoast.showToast(msg: res['message'], textColor: Colors.red);
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.black,
              ),
            ),
            Text(
              'Back',
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  Widget _LoginText() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an Account ? Login',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
