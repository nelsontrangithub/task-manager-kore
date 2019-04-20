import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kore_app/models/contract.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/data/signin.dart';
import 'package:kore_app/screens/taskDetail.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ContractDetailState extends State<ContractDetail> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _tasks = <Task>[];
  int _count = 0;

  //test
  RestDatasource datasource = new RestDatasource();

  //one of the state lifecycle function, only load once
  //good place for dummydata loading
  @override
  initState() {
    super.initState();

    /*dummy data*/
    _tasks.add(Task(1, "Task 1", false, "This is the description",
        DateTime.utc(2020, 6, 6)));
    _tasks.add(Task(2, "Task 2", false, "This is the description",
        DateTime.utc(2020, 6, 6)));
    // _tasks.add(Task("Task 3", true));
    // _tasks.add(Task("Task 4", false));
    // _tasks.add(Task("Task 5", false));
    // _tasks.add(Task("Task 6", false));
    // _tasks.add(Task("Task 7", true));
    //initialized the number of completed task
    _tasks.map((task) => () {
          if (task.isCompleted) {
            _count++;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contract.title),
        // actions: <Widget>[      // Add 3 lines from here...
        //     IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        //   ],
      ),
      body: new Column(
          children: <Widget>[_buildPercentIndicator(), _buildList()]),
    );
  }

  Widget _buildPercentIndicator() {
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: new CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 13.0,
        animation: true,
        percent: widget.contract.percentage * 0.01,
        center: new Text(
          widget.contract.percentage.toString() + "%",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        footer: new Text(
          "Progress",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        progressColor: Colors.purple,
      ),
    );
  }

  Widget _buildList() {
    return Flexible(child: ListView.builder(
        // padding: const EdgeInsets.symmetric(vertical: 25.0),
        itemBuilder: (context, i) {
      // if (i.isOdd) return Divider();

      // final index = i ~/ 2;
      if (_tasks.length > i) {
        return _buildRow(_tasks[i], i);
      }
      return null;
    }));
  }

  Widget _buildRow(Task task, int index) {
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: new Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: new ListTile(
          leading: new CircleAvatar(
            backgroundColor: Colors.indigo[700],
            child: new Text((index + 1).toString()),
            foregroundColor: Colors.white,
          ),
          title: new Text(task.title),
          subtitle: new Text('subtitle'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetail(task: task),
                ));
          },
        ),
      ),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Upload',
          color: Colors.blueAccent,
          icon: Icons.file_upload,
        ),
        new IconSlideAction(
          caption: 'Complete',
          color: Colors.green[800],
          icon: Icons.done,
          onTap: () => markComplete(task),
        ),
      ],
    );
  }

  markComplete(Task task) {
    task.isCompleted = !task.isCompleted;
    print(task.isCompleted);
  }
}

class ContractDetail extends StatefulWidget {
  final Contract contract;

  const ContractDetail({Key key, this.contract}) : super(key: key);

  @override
  ContractDetailState createState() => new ContractDetailState();
}
