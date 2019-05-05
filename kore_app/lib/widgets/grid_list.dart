import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/screens/user_list.dart';
import 'package:kore_app/utils/constant.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:kore_app/widgets/loading_indicator.dart';

class GridListState extends State<GridList> {
  final _biggerFont = THEME_TEXTSTYLE.copyWith(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.w400);
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
                height: 100.0,
                child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: 
                      ListView.builder(
                          itemCount: widget.role == Constant.AdminRole ? snapshot.data.length + 1 : snapshot.data.length,
                          // This next line does the trick.
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            if (i < snapshot.data.length) {
                              return _buildGridCell(snapshot.data[i]);
                            } else {
                              return _buildGridCell(null);
                            }
                          })
                    ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return LoadingIndicator();
        });
  }

  Widget _buildGridCell(User user) {
    return new Container(
      margin: new EdgeInsets.only(left: 30.0, top: 10),
      child: 
        user != null ? Column(
        children: 
            <Widget>[ CircleAvatar(
                    radius: 35,
                    backgroundColor: KorePrimaryColor,
                    child: ClipOval(
                        child: CachedNetworkImage(
                      imageUrl: user.iconFileUrl == null
                          ? Constant.PHOTO_PLACEHOLDER_PATH
                          : user.iconFileUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ))), Text(user.name)])
            : Row(
              children: <Widget> [
              Material(
                elevation: 1.0,
                shape: CircleBorder(side: BorderSide.none),
                color: Color(0xff1282c5),
                child: MaterialButton(
                  highlightElevation: 0,
                  padding: const EdgeInsets.all(10),
                  minWidth: 100,
                  onPressed: () {
                    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AssignTask(
              userRepository: widget.userRepository, task: widget.task, func: widget.func, isDelete: false
            )));
                  },
                  child: Icon(Icons.add, size: 50, color: Colors.white),
                ),
              ),
        Material(
                elevation: 1.0,
                shape: CircleBorder(side: BorderSide.none),
                color: Color(0xff1282c5),
                child: MaterialButton(
                  highlightElevation: 0,
                  padding: const EdgeInsets.all(10),
                  minWidth: 100,
                  onPressed: () {
                    Navigator.push(
            context, MaterialPageRoute(builder: (context) => AssignTask(
              userRepository: widget.userRepository, task: widget.task, func: widget.func, isDelete: true
            )));
                  },
                  child: Icon(Icons.remove, size: 50, color: Colors.white),
                ),
              ),
      ]),
    );
  }
}

class GridList extends StatefulWidget {
  final Future<List<User>> users;
  final UserRepository userRepository;
  final Task task;
  final Function func;
  final String role;

  GridList({Key key, @required this.users, @required this.userRepository, @required this.task, @required this.func, @required this.role}) : 
  assert(users != null),
  assert(userRepository != null),
  assert(task != null),
  assert(func != null),
  assert(role != null),
  super(key: key);

  @override
  GridListState createState() => new GridListState();
}
