import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/widgets/basic_list.dart';
import 'package:kore_app/widgets/profile_header.dart';

class OrganizationListState extends State<OrganizationList> {
  static const PHOTO_PLACEHOLDER_PATH =
      "https://image.flaticon.com/icons/png/128/201/201570.png";

  Future<User> _user;
  Future<List<Organization>> _organizations;
  Future<String> _username;
  Future<String> _token;
  Api _api;

  @override
  initState() {
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _organizations = _api.getOrganizations(_token);
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        body: Stack(children: <Widget>[
      Column(children: <Widget>[
        ProfileHeader(user: _user),
        BasicList(
            user: _user,
            list: _organizations,
            userRepository: widget.userRepository,
            role: widget.role)
      ]),
      Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text('Origanizations'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  authenticationBloc.dispatch(LoggedOut());
                  //               Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                  // builder: (BuildContext context) =>
                  // new MyHomePage(userRepository: widget.userRepository)), (Route<dynamic> route) => false);
                },
              ),
            ],
          )),
    ]));
  }
}

class OrganizationList extends StatefulWidget {
  OrganizationList(
      {Key key, @required this.userRepository, @required this.role})
      : assert(userRepository != null),
        assert(role != null),
        super(key: key);

  final UserRepository userRepository;
  final String role;

  @override
  OrganizationListState createState() => new OrganizationListState();
}
