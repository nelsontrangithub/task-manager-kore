import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';

class OrganizationListState extends State<OrganizationList> {
  Future<User> _user;
  Future<List<Organization>> _organizations;
  Future<String> _username;
  Future<String> _token;

  @override
  initState(){
    super.initState();
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
  @override
  OrganizationListState createState() => new OrganizationListState();
}