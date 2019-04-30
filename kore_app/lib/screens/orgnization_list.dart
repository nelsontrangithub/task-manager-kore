import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/screens/account_list.dart';
import 'package:kore_app/utils/constant.dart';
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
    final AuthenticationBloc authenticattionBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Organizations'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authenticattionBloc.dispatch(LoggedOut());
              },
            )
          ],
        ),
        body: FutureBuilder<List<Organization>>(
            future: _organizations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Column(
                  children: <Widget>[
                    ProfileHeader(user: _user),
                    _buildList(snapshot.data)
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget _buildList(List<Organization> organizations) {
    return Flexible(
        child: ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();
        final index = i ~/ 2;
        if (organizations.length > index) {
          return _buildRow(organizations[index]);
        }
        return null;
      },
    ));
  }

  Widget _buildRow(Organization organization) {
    return ListTile(
        title: Text(
          organization.name,
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountList(
                    organization: organization,
                    userRepository: widget.userRepository,
                    role: Constant.AdminRole),
              ));
        });
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
