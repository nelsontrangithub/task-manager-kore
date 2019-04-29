import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:kore_app/screens/accountList.dart';

class OrganizationListState extends State<OrganizationList> {
  static const PHOTO_PLACEHOLDER_PATH =
      "https://image.flaticon.com/icons/png/128/201/201570.png";
  
  UserRepository userRepository;
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
    _organizations = _api.getOrganizationsById(_token);
    _user = _api.getUserByUsername(_token, _username);
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticattionBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Organization List'),
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
                    _adminProfileRow(),
                    _buildList(snapshot.data)
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }));
  }

  Widget _adminProfileRow() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomLeft: const Radius.circular(30.0)),
          color: KorePrimaryColor,
        ),
        child: FutureBuilder<User>(
            future: _user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: new Container(
                      height: 150.0,
                      child: new CachedNetworkImage(
                        imageUrl: snapshot.data.iconFileUrl == null
                            ? PHOTO_PLACEHOLDER_PATH
                            : snapshot.data.iconFileUrl,
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      ),
                    )),
                    Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(snapshot.data.name),
                          new Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: new Text(snapshot.data.status.toString()),
                          )
                        ],
                      ),
                    )
                  ],
                );
              } else if (snapshot.error) {
                return Text("${snapshot.error}");
              }
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
                builder: (context) => AccountList(organization: organization, userRepository: userRepository),
              ));
        });
  }
}

class OrganizationList extends StatefulWidget {
  OrganizationList({Key key, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  final UserRepository userRepository;

  @override
  OrganizationListState createState() => new OrganizationListState();
}
