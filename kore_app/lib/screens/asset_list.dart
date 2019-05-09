import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/asset.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/s3bucketUploader.dart';
import 'package:kore_app/widgets/loading_indicator.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class AssetListState extends State<AssetList> {
  Future<User> _user;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  //file picker
  bool _hasValidMime = false;
  FileType _pickingType;

  TextEditingController _nameFieldController = TextEditingController();
  String _nameField;

  Future<List<Asset>> _assets;
  int _assetsLength;
  Future<String> _username;
  Future<String> _token;
  Api _api;

  initState() {
    super.initState();

    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _user = _api.getUserByUsername(_token, _username);
    _assets = _api.getAssets(_token, widget.task.id.toString());

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
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 12)),
              _buildButtonBar(),
              _buildAssetsListContainer(_assets),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButtonBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[_buildUploadButton()],
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
      child: FlatButton.icon(
        onPressed: () {
          openFileExplorer();
        },
        icon: Icon(Icons.file_upload, color: Colors.white),
        label: Text(
          'Upload File',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
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

  String mimeTypeTranslator(String assetMimeType) {
    String translatedMimeType;
    if (assetMimeType == "application/vnd.openxmlformats-officedocument.word") {
      translatedMimeType = "Word document";
    } else if (assetMimeType ==
        "application/vnd.openxmlformats-officedocument.spre") {
      translatedMimeType = "Excel document";
    } else if (assetMimeType ==
        "application/vnd.openxmlformats-officedocument.pres") {
      translatedMimeType = "Powerpoint document";
    } else if (assetMimeType == "application/pdf") {
      translatedMimeType = "PDF document";
    } else {
      translatedMimeType = assetMimeType;
    }
    return translatedMimeType;
  }

  String determineFileSize(int size) {
    String translatedSize;
    if (size < 1000000) {
      translatedSize = (size / 1000).toStringAsFixed(2) + "KB";
    } else if (size < 1000000000) {
      translatedSize = (size / 1000000).toStringAsFixed(2) + "MB";
    } else {
      translatedSize = (size / 1000000000).toStringAsFixed(2) + "GB";
    }
    return translatedSize;
  }

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateFormat formatter = new DateFormat("MMM d, yyyy h:mma");
    return formatter.format(date);
  }

  Widget _buildRow(Asset asset) {
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListTile(
          title: Text(
            asset.title,
            style: _biggerFont,
          ),
          subtitle: new Text(mimeTypeTranslator(asset.mimeType) +
              ", " +
              determineFileSize(asset.size) +
              "\n" +
              "Modified: " +
              formatDate(asset.dateModified)),
          onTap: () {},
        ),
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: "Download",
          color: Colors.indigo[900],
          icon: Icons.file_download,
          onTap: () {
            String url = asset.url + asset.location + "/" + asset.fileName;
            S3bucketUploader.downloadFile(url, asset.fileName);
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
        id: _fileName + taskId.toString(),
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
        file = await FilePicker.getFile(type: FileType.ANY);
      } on PlatformException catch (e) {
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
            getAssets();
          }
        }
      }
    }
  }
}

class AssetList extends StatefulWidget {
  final Task task;
  const AssetList({Key key, this.task, @required this.userRepository})
      : assert(userRepository != null),
        super(key: key);

  final UserRepository userRepository;

  @override
  AssetListState createState() => new AssetListState();
}
