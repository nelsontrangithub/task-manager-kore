import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/auth/authentication_state.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/screens/contractList.dart';
import 'package:kore_app/screens/loading_indicator.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/screens/splash_page.dart';
import 'package:kore_app/screens/login.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    super.onTransition(transition);
    print(transition.toString());
  }
}

// void main() => runApp(MyApp());
void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(MyApp(userRepository: UserRepository()));
}

class MyApp extends StatefulWidget {
  final UserRepository userRepository;
  MyApp({Key key, @required this.userRepository}) : super(key: key);
  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  AuthenticationBloc authenticationBloc;
  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Flutter login UI',
  //     theme: ThemeData(
  //       // This is the theme of your application.

  //     ),
  //     initialRoute: '/',
  //     routes: routes,
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return LoadingIndicator();
            }
            if (state is AuthenticationAuthenticated) {
              return ContractList();
            }
            if (state is AuthenticationUnauthenticated) {
              return MyHomePage(
                  title: 'Flutter Demo Home Page',
                  userRepository: UserRepository());
            }
            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
