import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kore_app/screens/asset_list.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/asset.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/screens/user_list.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:flutter/services.dart';
import 'package:kore_app/widgets/grid_list.dart';
import 'package:kore_app/widgets/loading_indicator.dart';
import '../models/task.dart';
import '../utils/theme.dart';
import '../utils/s3bucketUploader.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class TaskDetailState extends State<TaskDetail> {
  Future<User> _user;
  var icon;
  var iconColor;
  String text;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  //file picker
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;

  TextEditingController _controller = new TextEditingController();
  TextEditingController _nameFieldController = TextEditingController();
  String _nameField;

  Future<List<Asset>> _assets;
  int _assetsLength;
  Future<String> _username;
  Future<String> _token;
  Api _api;
  Future<List<User>> _users;

  initState() {
    super.initState();

    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _assets = _api.getAssets(_token, widget.task.id.toString());
    _users = _api.getUsersByTaskId(_token, widget.task);

    if (widget.task.status == 0) {
       icon = Icons.block;
      iconColor = Colors.redAccent;
      text = "Not Completed!";
    } else {
      icon = Icons.check;
      iconColor = Colors.green;
      text = "Completed!";    
    }
    _controller.addListener(() => _extension = _controller.text);
    _nameFieldController.addListener(() {
      _nameField = _nameFieldController.text;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.description),
      ),
      body: new ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 12)),
              _buildTaskDescription(),
              GridList(
                users: _users,
                userRepository: widget.userRepository,
                task: widget.task,
                func: _updateUserListCallback,
                role: widget.role,
              ),
              _buildCalendar(widget.task),
              _buildTaskEnd(),
            ],
          ),
        ],
      ),
    );
  }

  _updateUserListCallback() {
    setState(() {
      Future.delayed(const Duration(seconds: 1), () => "1");
      _users = _api.getUsersByTaskId(_token, widget.task);
    });
  }

  Widget _assignTask() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AssignTask(
                      userRepository: widget.userRepository,
                      task: widget.task,
                    )));
      },
      icon: Icon(Icons.account_circle),
      label: Text("Assign Task"),
    );
  }

  Widget _buildCalendar(Task task) {
    return Container(
        child: Card(
      color: Colors.white,
      child: CalendarCarousel(
        dayPadding: 0,
        height: 400,
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        todayTextStyle: TextStyle(fontSize: 20),
        selectedDayTextStyle: TextStyle(fontSize: 20),
        todayButtonColor: KorePrimaryColor,
        selectedDateTime: widget.task.dueDate,
        selectedDayButtonColor: Colors.red,
      ),
    ));
  }

  Widget _buildTaskDescription() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text(
                  "Description: ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.task.description,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10),),
                    Text("Status: " + text, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: iconColor
                    ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskEnd() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[_buildUploadButton()],
          ),
          Column(
            children: <Widget>[_buildDoneButton()],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Material(
      elevation: 6.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff1282c5),
      child: FlatButton.icon(
        onPressed: () {
          //upload button lauches asset list view
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AssetList(
                    userRepository: widget.userRepository,
                    task: widget.task,
                    key: widget.key)),
          );
        },
        icon: Icon(Icons.folder_open, color: Colors.white),
        label: Text(
          'Assets',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return Material(
      elevation: 6.0,
      shape: CircleBorder(side: BorderSide.none),
      color: iconColor,
      child: MaterialButton(
          minWidth: 100,
          onPressed: () {
            toggleCompleted(widget.task);
            widget.updatePercentCallBack();
          },
          child: Icon(
            icon,
            color: Colors.white,
          )),
    );
  }

  void toggleCompleted(Task task) {
    if (task.status == 0) {
      task.status = 1;
      _api.updateTaskStatus(_token, task, 1);
    } else {
      task.status = 0;
      _api.updateTaskStatus(_token, task, 0);
    }
    setState(() {
      if (task.status == 0) {
         icon = Icons.block;
        iconColor = Colors.redAccent;
        text = "Not Completed!";
        
      } else {
       icon = Icons.check;
        iconColor = Colors.green;
        text = "Completed!";
      }
      
    });
  }

  //Alert Dialog
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Done!"),
      onPressed: () {
        toggleCompleted(widget.task);
        Navigator.of(context).pop();
        widget.updatePercentCallBack();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Confirm Status Change"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class TaskDetail extends StatefulWidget {
  final Task task;
  final String role;
  final Function updatePercentCallBack;
  const TaskDetail(
      {Key key,
      this.task,
      @required this.userRepository,
      @required this.role,
      @required this.updatePercentCallBack})
      : assert(userRepository != null),
        assert(task != null),
        assert(updatePercentCallBack != null),
        super(key: key);

  final UserRepository userRepository;

  @override
  TaskDetailState createState() => new TaskDetailState();
}
