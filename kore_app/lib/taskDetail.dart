import 'package:flutter/material.dart';
import 'data/task.dart';
import 'package:kore_app/theme.dart';
import 'package:intl/intl.dart';

class TaskDetailState extends State<TaskDetail> {
  initState() {
    super.initState();

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.task.title)),
        body: new Column(
          children: <Widget>[
            _buildTaskHeader(),
            _buildTaskDescription(),
            _buildTaskEnd()
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

  Widget _buildTaskEnd() {

    var now = widget.task.dueDate;
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    print(formatted);


    return new Container(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.file_upload, color: KorePrimaryColor),
              title: Text("Due Date: " + formatted),
              subtitle: Text('Date Created:'),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Upload File'),
                    onPressed: () {/* ... */},
                  ),
                  FlatButton(
                    child: const Text('Task Done'),
                    onPressed: () {/* ... */},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskDetail extends StatefulWidget {
  final Task task;

  const TaskDetail({Key key, this.task}) : super(key: key);

  @override
  TaskDetailState createState() => new TaskDetailState();
}
