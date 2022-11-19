import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';

class notification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: ContactUsBottomAppBar(
          companyName: 'SAFENET',
          textColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 77, 158, 182),
          email: 'adoshi26.ad@gmail.com',
          // textFont: 'Sail',
        ),
        backgroundColor: Color.fromARGB(255, 0, 50, 150),
        body: ContactUs(
          cardColor: Colors.white,
          textColor: Colors.teal.shade900,
          //logo: AssetImage('images/logo.png'),
          email: 'dananjaya.nisansale@gmail.com',
          companyName: 'SAFENET',
          companyColor: Colors.teal.shade100,
          dividerThickness: 2,
          phoneNumber: '+94757652730',
          website:
              'https://cepdnaclk.github.io/e17-3yp-smart-apartment-security-system/',
          githubUserName:
              'https://github.com/cepdnaclk/e17-3yp-smart-apartment-security-system',
          tagLine: 'University of Peradeniya',
          taglineColor: Colors.teal.shade100,
        ),
      ),
    );
  }
}
