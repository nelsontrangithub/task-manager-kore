import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AssignTaskState extends State<AssignTask> {
  
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List names = new List();
  List filteredNames =  new List();

  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text("Search User");
  
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

  @override
  AssignTaskState createState() => new AssignTaskState();
}