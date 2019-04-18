import 'package:flutter/material.dart';
import 'package:kore_app/screens/contractDetail.dart';
import 'package:kore_app/screens/contractList.dart';
import 'package:kore_app/main.dart';

final routes = {
  '/contractList':         (BuildContext context) => new ContractList(),
  '/' :          (BuildContext context) => new MyHomePage(title: 'Flutter Demo Home Page'),
};