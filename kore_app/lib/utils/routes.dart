import 'package:flutter/material.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/screens/accountList.dart';
import 'package:kore_app/screens/login.dart';

final routes = {
  '/contractList':         (BuildContext context) => new AccountList(),
  '/' :          (BuildContext context) => new MyHomePage(title: 'Flutter Demo Home Page', userRepository: UserRepository()),
};