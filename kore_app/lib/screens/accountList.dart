import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/screens/accountDetail.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:kore_app/widgets/basic_list.dart';

class AccountListState extends State<AccountList> {
  Future<User>
      _user; // = User("Tina", "https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
  Future<List<Account>> _contracts;
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _nameFont = const TextStyle(color: Colors.white, fontSize: 28);
  static const PHOTO_PLACEHOLDER_PATH =
      "https://image.flaticon.com/icons/png/128/201/201570.png";
  Future<String> _username;
  Future<String> _token;
  Api _api;
  // final Set<ContractInfo> _saved = Set<ContractInfo>();
  //one of the state lifecycle function, only load once
  //good place for dummydata loading
  @override
  initState() {
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _contracts = _api.getAccountsById(_token, _user);
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: widget.organization == null
              ? Text('Accounts')
              : Text(widget.organization.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                authenticationBloc.dispatch(LoggedOut());
              },
            ),
          ],
        ),
        body: Column(children: <Widget>[
          _profileRow(),
          BasicList(
              user: _user,
              list: _contracts,
              userRepository: widget.userRepository)
        ]));
  }

  Widget _profileRow() {
    return FutureBuilder<User>(
        future: _user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                // margin: const EdgeInsets.symmetric(vertical: 0.0),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: const Radius.circular(30.0)),
                  color: KorePrimaryColor,
                ),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Using expanded to ensure the image is always sized with contraint
                    Expanded(
                      child: new Container(
                        height: 150.0,
                        // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: CachedNetworkImage(
                          imageUrl: snapshot.data.iconFileUrl == null
                              ? PHOTO_PLACEHOLDER_PATH
                              : snapshot.data.iconFileUrl,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(snapshot.data.name, style: _nameFont),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(snapshot.data.status.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(heightFactor: 0, widthFactor: 0,);
        });
  }
}

class AccountList extends StatefulWidget {
  final Organization organization;
  final UserRepository userRepository;

  AccountList({Key key, this.organization, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  @override
  AccountListState createState() => new AccountListState();
}
