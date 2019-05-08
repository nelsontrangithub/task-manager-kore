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
  // 1, "Tina","https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
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
    //_assets.add(new Asset(1, "asset1", "assetFIleName", "mime", 2, "here","/here", 1));

    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _assets = _api.getAssets(_token, widget.task.id.toString());
    _users = _api.getUsersByTaskId(_token, widget.task);

    if (widget.task.status == 0) {
      icon = Icons.check;
      iconColor = Colors.green;
      text = "Not Completed";
    } else {
      icon = Icons.block;
      iconColor = Colors.redAccent;
      text = "Completed";
    }
    _controller.addListener(() => _extension = _controller.text);
    _nameFieldController.addListener(() {
      print("CONTROLLER: $_nameFieldController");
      _nameField = _nameFieldController.text;
      print("_nameField" + _nameField);
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
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 12)),
              // _assignTask(),
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
      //  selectedDateTime: this.dueDate,
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
          //openFileExplorer();
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
            showAlertDialog(context);
          },
          child: Icon(
            icon,
            color: Colors.white,
          )),
    );
  }

  /* Start of Assets Functionality */

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
    _assetsLength = assets.length * 2;
    return Flexible(
        fit: FlexFit.loose,
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(25.0),
            itemCount: _assetsLength,
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
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: ListTile(
          title: Text(
            asset.title,
            style: _biggerFont,
          ),
          // trailing: Icon(
          //   // Add the lines from here...
          //   account.percentage >= 100 ? Icons.done : null,
          // ),
          onTap: () {},
        ),
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: "Update",
          color: Colors.blueAccent,
          icon: Icons.file_upload,
          onTap: () {
            //update file
          },
        ),
        new IconSlideAction(
          caption: "Delete",
          color: Colors.redAccent,
          icon: Icons.delete_forever,
          onTap: () async {
            bool s3Success = await _api.deleteAssetS3(_token, asset);
            if (s3Success) {
              bool dbSuccess = await _api.deleteAssetDb(_token, asset);
              print(dbSuccess);
              if (dbSuccess) {
                getAssets();
              }
            }
          },
        ),
      ],
    );
  }

  getAssets() {
    _assets = _api.getAssets(_token, widget.task.id.toString());
    setState(() => {});
  }

  //Alert box with input feild to allow users to assing a title to the selected file
  setFileTitle(BuildContext context, File file) async {
    _nameField = "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Selected: " + path.basename(file.path)),
            content: TextField(
              inputFormatters: [
                BlacklistingTextInputFormatter(RegExp("[/\\\\]")),
              ],
              controller: _nameFieldController,
              decoration: InputDecoration(hintText: "file title"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _nameField = "/";
                },
              ),
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<Asset> createAsset(File file, String title) async {
    String checkTitle;
    if (title == "") {
      checkTitle = "[Empty]";
    } else {
      checkTitle = title;
    }
    final _title = checkTitle;
    final _fileName = path.basename(file.path);
    final _mimeType = lookupMimeType(file.path);
    final _length = await file.length();
    final _location = widget.task.id.toString();
    final _path =
        "https://s3.us-east-2.amazonaws.com/koretaskmanagermediabucket/";
    final taskId = widget.task.id;
    final accountId = widget.task.accountId;

    Asset asset = new Asset(
        id: _fileName,
        title: _title,
        fileName: _fileName,
        mimeType: _mimeType,
        size: _length,
        location: _location,
        url: _path,
        taskId: taskId.toString(),
        accountId: accountId.toString(),
        status: 0);
    return asset;
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
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
    }

    if (file != null) {
      //Create Asset Object and assign a title.

      await setFileTitle(context, file);
      Asset asset;
      if (_nameField != "/") {
        asset = await createAsset(file, _nameField);
      }
      //If user did not hit cancel while assigning a file title.
      if (asset != null) {
        bool s3success = await S3bucketUploader.uploadFile(
            file, "koretaskmanagermediabucket", widget.task.id.toString());
        if (s3success) {
          User user = await _user;
          int dbSuccess = await _api.postAsset(_token, asset, user);

          if (dbSuccess > 0) {
            dbSuccess == 1
                ? print("Added asset successfully")
                : print("Updated asset successfully");
            getAssets();
          }
        }
      }
    }
  }

  /* End of Assets Functionality, to be moved into its own view at a later point */

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
        icon = Icons.check;
        iconColor = Colors.green;
        text = "Completed";
        _buildDoneButton();
      } else {
        icon = Icons.block;
        iconColor = Colors.redAccent;
        text = "Not Completed!";
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
        widget.updatePercentCallBack();
        // widget.task.setStatus(_api, _token, widget.task);
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
