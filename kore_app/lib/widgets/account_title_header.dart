/*
  this is a widget only show to admin user
*/
import 'package:flutter/material.dart';
import 'package:kore_app/models/organization.dart';
import 'package:kore_app/utils/theme.dart';

class AccountTitleHeader extends StatelessWidget {
  final Organization organization;

  AccountTitleHeader({Key key, @required this.organization}) : super(key: key);
  final _orgTitleFont = THEME_TEXTSTYLE.copyWith(fontSize: 48, color: Colors.white, fontWeight: FontWeight.w600);
  // const TextStyle(color: Colors.white, fontSize: 38);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200.0,
        // margin: const EdgeInsets.symmetric(vertical: 0.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          // borderRadius:
          //     BorderRadius.only(bottomLeft: const Radius.circular(30.0)),
          image: new DecorationImage(
            image: new AssetImage("assets/header_background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      organization.name,
                      style: _orgTitleFont,
                    )),
                // Container(
                //   margin: const EdgeInsets.only(top: 5.0),
                //   child: Text(organization.status.toString(),
                //       style: TextStyle(color: Colors.white, fontSize: 16)),
                // ),
              ],
            ),
          ],
        ));
  }
}
