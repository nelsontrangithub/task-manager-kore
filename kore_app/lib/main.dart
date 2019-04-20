import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/utils/routes.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

// void main() => runApp(MyApp());
void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp(userRepository: UserRepository());
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;
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
