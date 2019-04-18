import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../data/contract.dart';
import '../data/task.dart';

class ContractDetailState extends State<ContractDetail> {

  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _tasks = <Task>[];
  int _count = 0;

  //one of the state lifecycle function, only load once
  //good place for dummydata loading
  @override
  initState() {
    super.initState();

    /*dummy data*/
    _tasks.add(Task("Task 1", false));
    _tasks.add(Task("Task 2", false));
    _tasks.add(Task("Task 3", true));
    _tasks.add(Task("Task 4", false));
    _tasks.add(Task("Task 5", false));
    _tasks.add(Task("Task 6", false));
    _tasks.add(Task("Task 7", true));
    //initialized the number of completed task
          _tasks.map((task) => (){
            if(task.isCompleted){
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
      body: new Column(children: <Widget>[ _buildPercentIndicator(), _buildList()]),
    );
  }

  Widget _buildPercentIndicator() {
    return new Container (
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: new CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: true,
                percent: widget.contract.percentage*0.01,
                center: new Text(
                  widget.contract.percentage.toString() + "%",
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: new Text(
                  "Sales this week",
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.purple,
              ),
    );
  }

  Widget _buildList() {
    return Flexible(
        child: ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();

              final index = i ~/ 2;
              if (_tasks.length > index) {
                return _buildRow(_tasks[index]);
              }
              return null;
            }));
  }

  Widget _buildRow(Task task) {
    return ListTile(
      title: Text(
        task.title,
        style: _biggerFont,
      ),
      trailing: Icon(
        // Add the lines from here...
        task.isCompleted ? Icons.done : null,
      ),
      onTap: () {
        setState(() {
          task.isCompleted = !task.isCompleted;
          // if(task.isCompleted) _count++;
          // else _count--;
          // widget.contract.percentage = _count/_tasks.length;
        });
      },
    );
  }
}

class ContractDetail extends StatefulWidget {
  final Contract contract;

  const ContractDetail({Key key, this.contract}): super(key: key);

  @override
  ContractDetailState createState() => new ContractDetailState();
}