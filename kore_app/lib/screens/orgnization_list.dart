import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/auth/user_repository.dart';

class OrganizationListState extends State<OrganizationList> {
  Future<User> _user;
  Future<List<Organization>> _organizations;
  Future<String> _username;
  Future<String> _token;
  Api _api;

  @override
  initState(){
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api =Api();

  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticattionBloc =
      BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(

    );
  }

}

class OrganizationList extends StatefulWidget {
  OrganizationList({Key key, @required this.userRepository})
      : assert (userRepository != null),
        super(key: key);

        final UserRepository userRepository;

  @override
  OrganizationListState createState() => new OrganizationListState();
}