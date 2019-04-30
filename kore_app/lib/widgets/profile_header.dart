import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/theme.dart';

class ProfileHeader extends StatelessWidget {
  final Future<User> user;

  ProfileHeader({Key key, this.user}) : super(key: key);
  final _nameFont = const TextStyle(color: Colors.white, fontSize: 28);
  static const PHOTO_PLACEHOLDER_PATH =
      "https://image.flaticon.com/icons/png/128/201/201570.png";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
        future: user,
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
          return Center(
            heightFactor: 0,
            widthFactor: 0,
          );
        });
  }
}
