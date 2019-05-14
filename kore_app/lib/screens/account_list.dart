import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kore_app/auth/authentication_bloc.dart';
import 'package:kore_app/auth/authentication_event.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/screens/login.dart';
import 'package:kore_app/utils/constant.dart';
import 'package:kore_app/widgets/account_title_header.dart';
import 'package:kore_app/widgets/basic_list.dart';
import 'package:kore_app/widgets/profile_header.dart';
import 'package:after_layout/after_layout.dart';

class AccountListState extends State<AccountList> with AfterLayoutMixin<AccountList> {
  Future<User>
      _user;
  Future<List<Account>> _contracts;
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
    if (widget.role == Constant.AdminRole) {
      _contracts = _api.getAccountsByOrgId(_token, widget.organization);
    } else {
      _contracts = _api.getAccountsById(_token, _user);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // Calling the same function "after layout" to resolve the issue.

    returnToLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Column(children: <Widget>[
          widget.role == Constant.RegularRole
              ? ProfileHeader(user: _user)
              : AccountTitleHeader(organization: widget.organization),
          BasicList(
              user: _user,
              list: _contracts,
              userRepository: widget.userRepository,
              role: widget.role)
        ]),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Accounts'),
            actions: <Widget>[
              widget.role == Constant.RegularRole
                  ? IconButton(
                      icon: Icon(Icons.exit_to_app),
                      onPressed: () {
                        authenticationBloc.dispatch(LoggedOut());
                      },
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ],
    ));
  }
  returnToLoginScreen() async {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    if (await _contracts == null) {
        authenticationBloc.dispatch(LoggedOut());
   }
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
