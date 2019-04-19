import 'package:flutter/material.dart';
import 'package:kore_app/utils/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login UI',
      theme: ThemeData(
        // This is the theme of your application.
    
      ),
      initialRoute: '/',
      routes: routes,
    );
  }
}
