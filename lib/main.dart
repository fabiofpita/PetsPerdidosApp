import 'package:flutter/material.dart';
import 'package:petsperdidos/src/pages/landing_page.dart';
import 'package:petsperdidos/src/service/authentication.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        //title: 'Flutter login demo',
        //debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        //showSemanticsDebugger: true,
        home: new RootPage(auth: new Auth()));
  }
}
