// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_applcation/main.dart';
import 'package:flutter_applcation/screens/login_page.dart';
import 'package:flutter_applcation/screens/register_page.dart';


void main() {
  testWidgets("Login widget test", (WidgetTester tester) async {
    //find all widgets needed
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    final addField1 = find.byKey(ValueKey('textemail'));
    final addField2 = find.byKey(ValueKey('textpassword'));
    final addButton = find.byKey(ValueKey('loginbutton'));

    //execute the actual test
    
    await tester.enterText(addField1, "steve.1634503860671@gmail.com");
    await tester.enterText(addField2, "register");
    await tester.tap(addButton);
    await tester.pump(); //rebuilds your widget
    expect(find.text('steve.1634503860671@gmail.com'), findsOneWidget);
    expect(find.text('register'), findsOneWidget);
    //check outputs
    //expect(find.text("Make Widget Testing Video"), findsOneWidget);
  });

  

}