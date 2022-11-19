import 'package:flutter/material.dart';
import 'package:flutter_application/rest/rest_api.dart';
import 'package:flutter_application/screens/homeSO.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_auth/email_auth.dart';
import 'login_page.dart';

class LoginPageSO extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageSOState();
  }
}

class _LoginPageSOState extends State<LoginPageSO> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SharedPreferences _sharedPreferences;
  late String value;
  late EmailAuth emailAuth;
  var otpval = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.navigate_before),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (_) => LoginPage());
                Navigator.pushReplacement(context, route);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: Material(
          child: SingleChildScrollView(
              child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.black87],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 1.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.repeated)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "SAFENET",
                      style: GoogleFonts.sarpanch(
                          textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Login of Security Officer",
                      style: GoogleFonts.sarpanch(
                          textStyle: const TextStyle(
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
              child: const Icon(
                Icons.add_moderator,
                size: 120,
                color: Colors.white,
              ),
            ),
            const SizedBox(
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
                        style: const TextStyle(
                          color: Colors.black,
                          height: 2,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        controller: _passwordController,
                        style: const TextStyle(
                          color: Colors.black,
                          height: 2,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
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
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 15,
                ),
                ElevatedButton(
                  onPressed: () {
                    _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                        ? doLogin(
                            _emailController.text, _passwordController.text)
                        : Fluttertoast.showToast(
                            msg: 'All fields are required',
                            textColor: Colors.red);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ))),
    );
  }

  doLogin(String email, String password) async {
    _sharedPreferences = await SharedPreferences.getInstance();
    var res = await userLoginSO(email.trim(), password.trim());
    if (res['success']) {
      print(res['success']);
      String userEmail = res['user'][0]['email'];
      int userId = res['user'][0]['id'];
      value = userEmail;
      _sharedPreferences.setInt('userid', userId);
      _sharedPreferences.setString('usermail', userEmail);

      Route route = MaterialPageRoute(builder: (_) => sohome(value: value));
      Navigator.pushReplacement(context, route);
    } else {
      Fluttertoast.showToast(
          msg: 'Email and password not valid ?', textColor: Colors.red);
    }
  }
}
