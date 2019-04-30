/*
  this is a widget only show to admin user
*/
import 'package:flutter/material.dart';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/utils/theme.dart';

class AccountTitleHeader extends StatelessWidget {
  final Account account;

  AccountTitleHeader({Key key, @required this.account}) : super(key: key);
  final _nameFont = const TextStyle(color: Colors.white, fontSize: 28);
  static const PHOTO_PLACEHOLDER_PATH =
      "https://image.flaticon.com/icons/png/128/201/201570.png";

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(account.name, style: _nameFont),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(account.status.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
  }
  
}