import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/asset.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:flutter/services.dart';
import 'package:kore_app/widgets/loading_indicator.dart';
import '../models/task.dart';
import '../utils/theme.dart';
import '../utils/s3bucketUploader.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;

class TaskDetailState extends State<TaskDetail> {
  Future<User> _user;
   // 1, "Tina","https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
  var icon;
  var iconColor;
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
  Future<List<Asset>> _assets;
  Future<String> _username;
  Future<String> _token;
  Api _api;

  initState() {
    super.initState();
    //_assets.add(new Asset(1, "asset1", "assetFIleName", "mime", 2, "here","/here", 1));

    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _assets = _api.getAssets(_token);

    if (widget.task.status == 0) {
      icon = Icons.check;
      iconColor = Colors.green;
    } else {
      icon = Icons.block;
      iconColor = Colors.redAccent;
    }
    _controller.addListener(() => _extension = _controller.text);
    
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
            children: <Widget>[
              // _buildHeader(),
              _buildTaskDescription(),
              _buildCalendar(widget.task),
              _buildTaskEnd(),
              _buildAssetsListContainer(_assets)
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 0.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.only(bottomLeft: const Radius.circular(30.0)),
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
              // child: new CachedNetworkImage(
              //   imageUrl: _user.iconFileUrl,
              // ),
            ),
          ),
          Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.task.description,
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    'Status: ' + widget.task.status.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    'Id: ' + widget.task.id.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(Task task) {
    return Container(
        child: Card(
      // elevation: 0,
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
              subtitle: Text(
                widget.task.description,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
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
      elevation: 4.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff1282c5),
      child: MaterialButton(
        minWidth: 100,
        onPressed: () {
          openFileExplorer();
        },
        child: Text(
          'Upload File',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return Material(
      elevation: 4.0,
      shape: CircleBorder(side: BorderSide.none),
      color: iconColor,
      child: MaterialButton(
          minWidth: 100,
          onPressed: () {
            showAlertDialog(context);
          },
          child: Icon(
            icon,
            color: Colors.white,
          )),
    );
  }

  Widget _buildAssetsListContainer(Future<List<Asset>> assets) {
    return new Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FutureBuilder<List<Asset>>(
                future: assets,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildAssetList(snapshot.data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default, show a loading spinner
                  return LoadingIndicator();
                },
            ),
          ],
        ),
      ),
    );
  }

Widget _buildAssetList(List<Asset> assets) {
    return Flexible(
        fit: FlexFit.loose,
        child: ListView.builder(
          shrinkWrap: true,
            padding: const EdgeInsets.all(25.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();

              final index = i ~/ 2;
              if (assets.length > index) {
                return _buildRow(assets[index]);
              }
              return null;
            }));
  }

  Widget _buildRow(Asset asset) {
    return ListTile(
      title: Text(
        asset.title,
        style: _biggerFont,
      ),
      // trailing: Icon(
      //   // Add the lines from here...
      //   account.percentage >= 100 ? Icons.done : null,
      // ),
      onTap: () {
      },
    );
  }

  void toggleCompleted(Task task) {
    // task.isCompleted = !task.isCompleted;
    task.setStatus(_api, _token, task);
    setState(() {
      if (task.status == 0) {
        icon = Icons.check;
        iconColor = Colors.green;
        _buildDoneButton();
      } else {
        icon = Icons.block;
        iconColor = Colors.redAccent;
        _buildDoneButton();
      }
      // task.setStatus(_api);
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

  void openFileExplorer() async {
    File file;
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          file = await FilePicker.getFile(type: FileType.ANY);
          // _path = await FilePicker.getFilePath(
          //     type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      // setState(() {
      //   _fileName = _path != null
      //       ? _path.split('/').last
      //       : _paths != null ? _paths.keys.toString() : '...';
      // });
    }
    //in case user click on cancel
    if (file != null) {
      S3bucketUploader.uploadFile(file, "koretaskmanagermediabucket", "temp");
    }
  }
}

class TaskDetail extends StatefulWidget {
  final Task task;
  const TaskDetail({Key key, this.task, @required this.userRepository}) 
            : assert(userRepository != null), 
            super(key: key);

  final UserRepository userRepository;

  @override
  TaskDetailState createState() => new TaskDetailState();
}
