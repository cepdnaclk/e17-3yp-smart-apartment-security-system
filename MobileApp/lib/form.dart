import 'package:flutter/material.dart';

class FormTest extends StatefulWidget {
  @override
  _FormTestState createState() => _FormTestState();
}

class _FormTestState extends State<FormTest> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name;
  late String _houseno;
  late String _email;
  late String _password;
  late String _cpassword;
  late int _mobile;

  Widget _buildNameField() {
    return TextFormField(
      validator: (text) {
        return HelperValidator.nameValidate(text!);
      },
      //maxLength: 20,
      maxLines: 1,
      decoration:
          InputDecoration(labelText: 'Name', hintText: 'Enter your full name'),
      onSaved: (value) {
        _name = value!;
      },
    );
  }

  Widget _buildHouseField() {
    return TextFormField(
      validator: (text) {
        return HelperValidator.nameValidate(text!);
      },
      maxLength: 5,
      maxLines: 1,
      decoration: InputDecoration(
          labelText: 'House No', hintText: 'Enter your House Number'),
      onSaved: (value) {
        _houseno = value!;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      validator: (text) {
        if (text!.isEmpty) {
          return "Please enter a bvalid email";
        }
        return null;
      },
      //maxLength: 20,
      decoration:
          InputDecoration(labelText: 'Email', hintText: 'Enter your email'),
      onSaved: (value) {
        _email = value!;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      validator: (text) {
        if (text!.isEmpty) {
          return "Please enter a password";
        }
        return null;
      },
      maxLength: 8,
      decoration: InputDecoration(
          labelText: 'Password', hintText: 'Enter your password'),
      onSaved: (value) {
        _password = value!;
      },
    );
  }

  Widget _buildCPasswordField() {
    return TextFormField(
      obscureText: true,
      validator: (text) {
        if (text!.isEmpty) {
          return "Please enter a password again";
        }
        return null;
      },
      maxLength: 8,
      decoration: InputDecoration(
          labelText: 'Confirm Password', hintText: 'Enter your password again'),
      onSaved: (value) {
        _cpassword = value!;
      },
    );
  }

  Widget _buildMobileNumberField() {
    return TextFormField(
      validator: (text) {
        if (text!.isEmpty) {
          return "Please enter a mobile number";
        }
        return null;
      },
      //maxLength: 10,
      decoration: InputDecoration(
          labelText: 'Mobile Number', hintText: 'Enter a mobile number'),
      onSaved: (value) {
        _mobile = int.parse(value!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SAFENET - SIGN UP'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: _buildNameField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: _buildHouseField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: _buildEmailField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: _buildPasswordField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: _buildCPasswordField(),
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: _buildMobileNumberField(),
                ),
                SizedBox(height: 10),
                Container(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('valid form');
                        _formKey.currentState!.save();
                      } else {
                        print('not valid form');
                      }
                      return;
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelperValidator {
  static String? nameValidate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be atleast 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}
