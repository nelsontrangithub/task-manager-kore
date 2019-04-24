import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/auth/login_state.dart';
import 'package:kore_app/auth/login_event.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/login_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  final UserRepository userRepository;
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  UserRepository get _userRepository => widget.userRepository;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
      authenticationBloc: _authenticationBloc,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Email Field
    final emailField = TextFormField(
      controller: _usernameController,
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    // Password Field
    final passwordField = TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    // Login Button
    Widget _buildLoginButton(LoginState state) {
      return Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(0xff1282c5),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          // Here is coming the funcion to login
          onPressed: () {
            // Navigator.pushNamed(context, '/contractList');
            state is! LoginLoading ? _onLoginButtonPressed() : null;
          },
          child: Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState state,
      ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
        return Scaffold(
          body: Center(
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/KORE-Logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 45.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(height: 35.0),
                      _buildLoginButton(state),
                      SizedBox(height: 15.0),
                      Container(
                        child: state is LoginLoading
                            ? CircularProgressIndicator()
                            : null,
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    _loginBloc.dispatch(LoginButtonPressed(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
