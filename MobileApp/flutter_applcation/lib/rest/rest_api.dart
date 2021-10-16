import 'dart:convert';
import 'package:http/http.dart' as http;

Future userLogin(String email, String Password) async {
  final response = await http.post(Uri.parse("http://10.0.2.2:3000/user/login"),
      headers: {"Accept": "Application/json"},
      body: {'email': email, 'password': Password});

  var decodeData = jsonDecode(response.body);
  return decodeData;
}

Future userLoginSO(String email, String Password) async {
  final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/user/loginSO"),
      headers: {"Accept": "Application/json"},
      body: {'email': email, 'password': Password});

  var decodeData = jsonDecode(response.body);
  return decodeData;
}

Future userRegister(String username, String email, String Password,
    String phone, String houseid, String apartmentid) async {
  final response = await http
      .post(Uri.parse("http://10.0.2.2:3000/user/register"), headers: {
    "Accept": "Application/json"
  }, body: {
    'name': username,
    'email': email,
    'phone': phone,
    'password': Password,
    'houseid': houseid,
    'apartmentid': apartmentid
  });

  var decodeData = jsonDecode(response.body);
  return decodeData;
}
