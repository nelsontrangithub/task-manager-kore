import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/widgets/user_row.dart';

class AssignTaskState extends State<AssignTask> {
  final TextEditingController _filter = new TextEditingController();

  Future<User> _user;
  Future<List<User>> _allUsers;
  Future<String> _username;
  Future<String> _token;
//  Future<String> value;
  Api _api;
  String val;
 // Future<List<User>> searchUser;

  @override
  void initState() {
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _allUsers = _api.getAllUsers(_token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("")),
        body: FutureBuilder<List<User>>(
            future: _allUsers,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Container(
                  padding: EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Column(
                    children: <Widget>[
                      _buildSearch(),
                      _buildList(snapshot.data)
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget _buildSearch() {
    return TextField(
      controller: _filter,
      onSubmitted: (value) {
        setState(() {
          _allUsers = _api.searchUserByUsername(_token, value);
        });
      },
      decoration: InputDecoration(
          labelText: "Search",
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
    );
  }

  Widget _buildList(List<User> users) {
    return Flexible(
      child: ListView.builder(
      itemCount: users.length*2,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (users.length > index) {
          return UserRow(user: users[index], task: widget.task, token: _token, api: _api);
        }
        return null;
      },
    ));
  }

  Widget _buildRow(User user) {
    return ListTile(
      leading: Icon(Icons.contacts),
      title: Text(
        user.email,
      
      ),
      subtitle: Text(
        user.name
      ),
      onTap: () async {
      _api.assignUserToTask(_token, widget.task.id.toString(), user.id.toString());
      },
    );
  }
}

class AssignTask extends StatefulWidget {
  final UserRepository userRepository;
  final Task task;
  final String role;

  const AssignTask({Key key, this.userRepository, this.task, this.role}) : super(key: key);
  @override
  AssignTaskState createState() => new AssignTaskState();
}
