import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/constant.dart';

class UserRow extends StatelessWidget {
  final User user;
  UserRow({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: "user_image",
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.iconFileUrl == null
                  ? Constant.PHOTO_PLACEHOLDER_PATH
                  : user.iconFileUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ))),
          title: Text(user.name),
          subtitle: Text(user.email),
    );
  }
}
