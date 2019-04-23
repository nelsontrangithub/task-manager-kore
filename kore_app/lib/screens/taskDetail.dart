import 'package:flutter/material.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

class TaskDetailState extends State<TaskDetail> {
 var text;
 
  initState() {
    super.initState();
     if (widget.task.isCompleted = true){
       text = "Mark Not Complete";
     } else {
       text = 'Mark Complete';
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

    void markCompleted(Task task){
      task.isCompleted = true;
      setState(() {
        text = 'Mark Not Completed';
      });
      print('markCompleted');
    }

    void markNotCompleted(Task task){
      task.isCompleted = false;
      setState(() {
        text = 'Mark Completed';
      });
      print('markNotCompleted');
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
                    },
                  ),
                  FlatButton(
                    child: 
                       Text(text),
                    onPressed: () {
                      task.isCompleted ? markNotCompleted(task) : markCompleted(task);
                  
/*onPressed: () {
            // Navigator.pushNamed(context, '/contractList');
            state is! LoginLoading ? _onLoginButtonPressed() : null;
          }, */

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
}

class TaskDetail extends StatefulWidget {
  final Task task;

  const TaskDetail({Key key, this.task}) : super(key: key);

  @override
  TaskDetailState createState() => new TaskDetailState();
}
