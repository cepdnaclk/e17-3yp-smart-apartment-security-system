import 'package:email_validator/email_validator.dart';
/*
4 --> sucess
2 --> both email and password are invalid
1 --> password is invalid
0 --> email is invalid
*/

// ignore: non_constant_identifier_names
// ignore: missing_return
int validate_login(String email, String password){
  if(validate_email(email) && validate_password(password) ){
    return 4;
  }
  else if (!validate_email(email) && !validate_password(password)){
    return 2;
  }
  else if (!validate_password(password)){
    return 1;
  }
  else if (!validate_email(email)){
    return 0;
  }else{
    return 5;
  }
}

// ignore: non_constant_identifier_names
bool validate_password(String passwd){
  // ignore: unnecessary_null_comparison
  if(passwd == null) return false;
  else if(passwd.length <4) return false;
  else return true ;
}

// ignore: non_constant_identifier_names
bool validate_email(String email){
  // ignore: unnecessary_null_comparison
  if (email == null) return false;
  else if(!EmailValidator.validate(email)) return false;
  // ignore: unnecessary_null_comparison
  else if(email != null && EmailValidator.validate(email)) return true;
  else return false;

}

