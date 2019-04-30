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
import 'package:kore_app/utils/theme.dart';
import 'package:kore_app/widgets/basic_list.dart';
import 'package:kore_app/widgets/profile_header.dart';

class AccountListState extends State<AccountList> {
  Future<User>
      _user; // = User("Tina", "https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
  Future<List<Account>> _contracts;
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
          ProfileHeader(user: _user),
          BasicList(
              user: _user,
              list: _contracts,
              userRepository: widget.userRepository)
        ]));
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
