import 'package:flutter/material.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/screens/taskDetail.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/task.dart';
import 'package:kore_app/auth/user_repository.dart';

class AccountDetailState extends State<AccountDetail> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _tasks = <Task>[];
  Future<User> _user;
  Future<List<Task>> _tasksAPI;
  Future<String> _username;
  Future<String> _token;
  Api _api;


  int _count = 0;
  var text;
  var color;
  var icon;
  var completeIcon;

  //test
  // Api _api = Api();

  //one of the state lifecycle function, only load once
  //good place for dummydata loading
  @override
  initState() {
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    _tasksAPI = _api.getTasks(_token);
    _user = _api.getUserByUsername(_token, _username);

    /*
    if (task){
       text = "Mark Not Complete";
     } else {
       text = 'Mark Complete';
     }
    */

    /*dummy data*/
    // _tasks.add(Task(
    //     1,
    //     "Task 1",
    //     false,
    //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
    //     DateTime.utc(2019, 4, 26)));
    // _tasks.add(Task(2, "Task 2", false, "This is the description",
        // DateTime.utc(2019, 6, 6)));
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.account.accountName),
        // actions: <Widget>[      // Add 3 lines from here...
        //     IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        //   ],
      ),
      body: new Column(children: <Widget>[
        _buildHeader(),
       // _buildPercentIndicator(),
        _buildList()
      ]),
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
              child: Column(
                children: <Widget>[
                  _buildPercentIndicator(),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  Widget _buildPercentIndicator() {
    return new Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: new CircularPercentIndicator(
          radius: 95.0,
          lineWidth: 13.0,
          animation: true,
          percent: widget.account.percentage * 0.01,
          center: new Text(
            widget.account.percentage.toString() + "%",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          footer: new Text(
            "Progress",
            style: new TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold, 
              fontSize: 17.0),
          ),
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Colors.white,
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
          trailing: Icon(completeIcon),
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
          caption: task.label,
          color: task.color,
          icon: task.icon,
          onTap: () {
            task.isCompleted ? markNotCompleted(task) : markCompleted(task);
          },
        ),
      ],
    );
  }

  void markCompleted(Task task) {
    task.isCompleted = true;

    setState(() {
      task.setStatus();
    });

    print(task.isCompleted);
  }

  void markNotCompleted(Task task) {
    task.isCompleted = false;

    setState(() {
      task.setStatus();
    });

    print(task.isCompleted);
  }
}

class AccountDetail extends StatefulWidget {
  final Account account;
  const AccountDetail({Key key, @required this.userRepository, this.account})
      : assert(userRepository != null),
        super(key: key);

  final UserRepository userRepository;

  @override
  AccountDetailState createState() => new AccountDetailState();
}
