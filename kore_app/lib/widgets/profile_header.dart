import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/theme.dart';

class ProfileHeader extends StatelessWidget {
  final Future<User> user;

  ProfileHeader({Key key, this.user}) : super(key: key);
  final _nameFont = THEME_TEXTSTYLE.copyWith(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600);
  static const PHOTO_PLACEHOLDER_PATH =
      "https://image.flaticon.com/icons/png/128/201/201570.png";

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: const EdgeInsets.symmetric(vertical: 0.0),
        // padding: const EdgeInsets.symmetric(vertical: 10.0),
        height: 280,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomLeft: const Radius.circular(60.0)),
          // color: KorePrimaryColor,
          image: new DecorationImage(
            image: new AssetImage("assets/header_background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<User>(
            future: user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Using expanded to ensure the image is always sized with contraint
                    Expanded(
                      child: new Container(
                        margin: const EdgeInsets.only(top: 80.0),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: Text(snapshot.data.name, style: _nameFont),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            child: Text(snapshot.data.status.toString(),
                                style: THEME_TEXTSTYLE.copyWith(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w200)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Center(
                heightFactor: 0,
                widthFactor: 0,
              );
            }));
  }
}
