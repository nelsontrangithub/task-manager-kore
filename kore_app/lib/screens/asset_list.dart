
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/models/asset.dart';

class AssetListState extends State<AssetList> {

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
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("asset list page"),
        ),
      body: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              // _buildHeader(),
               //_buildAssetsListContainer(_assets),
          
            ],
          ),
        ],
      ),
    );
  }


}


class AssetList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
  
}