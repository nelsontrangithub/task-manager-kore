import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/widgets/profile_header.dart';

class AssignTaskState extends State<AssignTask> {
   final TextEditingController _filter = new TextEditingController();
   String _searchText = "";
   List names = new List();
   List filteredNames = new List();
   Icon _searchIcon = new Icon(Icons.search);
   Widget _appBarTitle = new Text("Search User");

  Future<User> _user;
  Future<List<User>> _allUsers;
  Future<String> _username;
  Future<String> _token;
  Api _api;

  @override
  void initState() {
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _allUsers = _api.getAllUsers(_token);

    // void _getNames(List<User> _allUsers) async {
    //   List tempList = new List();
    //   for (int i = 0; i < _allUsers.length; i++) {
    //     tempList.add(_allUsers[i]);
    //     setState(() {
    //       names = tempList;
    //       filteredNames = names;
    //     });
    //   }
    // }
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
               hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search User');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  Widget _buildBar(BuildContext context){
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      )
    );
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

  // Widget _buildList() {
  //   if (!(_searchText.isEmpty)) {
  //     List tempList = new List();

  //     for (int i = 0; i < filteredNames.length; i++) {
  //       if (filteredNames[i]
  //           .toLowerCase()
  //           .contains(_searchText.toLowerCase())) {
  //         tempList.add(filteredNames[i]);
  //       }
  //     }
  //     filteredNames = tempList;
  //   }
  //   return ListView.builder(
  //       itemCount: names == null ? 0 : filteredNames.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return new ListTile(
  //           title: Text(filteredNames[index]),
  //         );
  //       },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildBar(context),
        body: FutureBuilder<List<User>>(
            future: _allUsers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Column(
                  children: <Widget>[
                    _buildList(snapshot.data)],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget _buildList(List<User> users) {
    return Flexible(
        child: ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (users.length > index) {
          return _buildRow(users[index]);
        }
        return null;
      },
    ));
  }

  Widget _buildRow(User organization) {
    return ListTile(
      title: Text(
        organization.name,
      ),
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
