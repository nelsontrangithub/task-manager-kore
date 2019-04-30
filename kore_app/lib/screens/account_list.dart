import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/constant.dart';
import 'package:kore_app/widgets/account_title_header.dart';
import 'package:kore_app/widgets/basic_list.dart';
import 'package:kore_app/widgets/profile_header.dart';

class AccountListState extends State<AccountList> {
  Future<User>
      _user; // = User("Tina", "https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
  Future<List<Account>> _contracts;
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
    if (widget.role == Constant.AdminRole) {
      _contracts = _api.getAccountsByOrgId(_token, widget.organization);
    } else {
      _contracts = _api.getAccountsById(_token, _user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Accounts'),
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
          widget.role == Constant.RegularRole
              ? ProfileHeader(user: _user)
              : AccountTitleHeader(organization: widget.organization),
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
  final String role;

  AccountList(
      {Key key,
      this.organization,
      @required this.userRepository,
      @required this.role})
      : assert(userRepository != null),
        assert(role != null),
        super(key: key);

  @override
  AccountListState createState() => new AccountListState();
}
