import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/constant.dart';
import 'package:kore_app/utils/theme.dart';

class ProfileHeader extends StatelessWidget {
  final Future<User> user;

  ProfileHeader({Key key, this.user}) : super(key: key);
  final _nameFont = THEME_TEXTSTYLE.copyWith(
      fontSize: 28, color: Colors.white, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 280,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomLeft: const Radius.circular(60.0)),
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
                  children: <Widget>[
                    //Using expanded to ensure the image is always sized with contraint
                    Expanded(
                      child: new Container(
                          margin: const EdgeInsets.only(top: 80.0),
                          height: 150.0,
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data.iconFileUrl == null
                                      ? Constant.PHOTO_PLACEHOLDER_PATH
                                      : snapshot.data.iconFileUrl,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ))),
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
                            child: Text(snapshot.data.email.toString(),
                                style: THEME_TEXTSTYLE.copyWith(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w200)),
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
