import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/constant.dart';

class UserRow extends StatelessWidget {
  final User user;
  final Future<String> token;
  final Task task;
  final Api api;
  UserRow({Key key, @required this.user, @required this.token, @required this.task, @required this.api})
      : assert(user != null),
        assert(token != null),
        assert(task != null),
        assert(api != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.iconFileUrl == null
                  ? Constant.PHOTO_PLACEHOLDER_PATH
                  : user.iconFileUrl,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )),
          title: Text(user.name),
          subtitle: Text(user.email),
          onTap: (){
              api.assignUserToTask(token, task.id.toString(), user.id.toString());
          },
    );
  }
}
