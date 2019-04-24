import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../models/task.dart';

class TaskDetailState extends State<TaskDetail> {
 var text;
 var textcolor;
 
  initState() {
    super.initState();
     _controller.addListener(() => _extension = _controller.text);
    print(widget.task.isCompleted);
     if (widget.task.isCompleted == true){
       text = "Mark Not Complete";
       textcolor = Colors.redAccent;
     } else {
       text = 'Mark Complete';
       textcolor = Colors.green[800];
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.task.title)),
        body: new Column(
          children: <Widget>[
            _buildTaskHeader(),
            _buildTaskDescription(),
            _buildTaskEnd(widget.task),
          ],
        ));
  }

  Widget _buildTaskHeader() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(5, 30, 5, 5),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.contacts, color: KorePrimaryColor),
              title: Text(widget.task.title),
              subtitle: Text('Id: ' + widget.task.id.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDescription() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.description, color: KorePrimaryColor),
              title: Text("Description"),
              subtitle: Text(widget.task.description),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskEnd(Task task) {

    var now = widget.task.dueDate;
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);


void toggleCompleted(Task task){
  task.isCompleted = !task.isCompleted;
  setState(() {
      if (task.isCompleted == true){
        text = 'Status: Not Complete';
        textcolor = Colors.redAccent;
      } else{
        text = 'Status: Complete';
        textcolor = Colors.green[800];
      }
      task.setStatus();
    });
}


    return new Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.file_upload, color: KorePrimaryColor),
              title: Text("Due: " + formatted),
              subtitle: Text('Date Created:'),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child:  Text('Upload File'),
                    onPressed: () {
                      openFileExplorer();
                    },
                  ),
                  FlatButton(
                    child: 
                       Text(text),
                       textColor: textcolor,
                    onPressed: () {
                      toggleCompleted(task);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();

  void openFileExplorer() async {
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(type: _pickingType, fileExtension: _extension);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null ? _path.split('/').last : _paths != null ? _paths.keys.toString() : '...';
        print(_fileName);
        print(_path);
      });
    }
  }


}

class TaskDetail extends StatefulWidget {
  final Task task;
  const TaskDetail({Key key, this.task}) : super(key: key);

  @override
  TaskDetailState createState() => new TaskDetailState();
}
