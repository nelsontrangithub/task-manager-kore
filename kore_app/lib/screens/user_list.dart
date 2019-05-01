import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/models/user.dart';

class AssignTaskState extends State<AssignTask> {
  
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  
  Future<User> _user;
  Future<List<Organization>> _organizations;
  Future<String> _username;
  Future<String> _token;
  Api _api;

  List filteredNames =  new List();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text("Search User");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);

}

  
  // Callback function when search icon is pressed
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search User');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  //Listener to TextEditingController
  AssignTaskState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign Task"),
      ),
      body: new ListView() 
    );
  }
}

class AssignTask extends StatefulWidget {

  final UserRepository userRepository;
  final String role;

  const AssignTask({Key key, this.userRepository, this.role}) : super(key: key);
  @override
  AssignTaskState createState() => new AssignTaskState();
}