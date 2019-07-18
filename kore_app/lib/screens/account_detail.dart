import 'package:flutter/material.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/auth/user_repository.dart';
import 'package:kore_app/utils/constant.dart';
import 'package:kore_app/widgets/loading_indicator.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:kore_app/models/account.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/data/api.dart';
import 'package:kore_app/screens/taskDetail.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/task.dart';

class AccountDetailState extends State<AccountDetail> {
  Future<User> _user;
  Future<List<Task>> _tasksAPI;
  Future<String> _username;
  Future<String> _token;
  Future<double> _percent;
  double newPercent;
  Api _api;

  var text;
  var color;
  var icon;
  var completeIcon;

  //one of the state lifecycle function, only load once
  //good place for dummydata loading
  @override
  initState() {
    super.initState();
    _token = widget.userRepository.hasToken();
    _username = widget.userRepository.getUsername();
    _api = Api();
    if (widget.role == Constant.RegularRole) {
      _user = _api.getUserByUsername(_token, _username);
      _tasksAPI = _api.getTasks(_token, _user, widget.account);
      _percent =
          _api.getPercentageOfTasksCompleted(_token, _user, widget.account);
    } else {
      _user = _api.getUserByUsername(_token, _username);
      _tasksAPI = _api.getAllTasksByAccountId(_token, widget.account);
      _percent =
          _api.getPercentageOfTasksCompleted(_token, _user, widget.account);
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _percent =
          _api.getPercentageOfTasksCompleted(_token, _user, widget.account);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(        
          title: Text(widget.account.name),
        ),
        body: FutureBuilder<List<Task>>(
          future: _tasksAPI,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Column(children: <Widget>[
                _buildHeader(),
                _buildList(snapshot.data)
              ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return LoadingIndicator();
          },
        ));
  }

  Widget _buildHeader() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomLeft: const Radius.circular(30.0)),
        ),
        child: FutureBuilder<double>(
          future: _percent,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //Using expanded to ensure the image is always sized with contraint
                    Expanded(
                        child: new Container(
                            height: 150.0,
                            child: Column(children: <Widget>[
                              _buildPercentIndicator(snapshot.data),
                            ])))
                  ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return LoadingIndicator();
          },
        ));
  }

  _updatePercentageIndicator() {
    Future.delayed(
        const Duration(milliseconds: 300),
        () => setState(() {
               _percent =
          _api.getPercentageOfTasksCompleted(_token, _user, widget.account);
            }));
  }

  Widget _buildPercentIndicator(double _percent) {
    return new Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: new CircularPercentIndicator(
        radius: 95.0,
        lineWidth: 13.0,
        animation: true,
        percent: _percent,
        center: new Text(
          (_percent * 100.0).round().toString() + "%",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
        footer: new Text(
          "Progress",
          style: new TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: Colors.grey,
        progressColor: Colors.indigo,
      ),
    );
  }

  Widget _buildList(List<Task> _tasks) {
    return Flexible(
        child: ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();

              final index = i ~/ 2;
              if (_tasks.length > index) {
                return _buildRow(_tasks[index], index);
              }
              return null;
            }));
  }

  Widget _buildRow(Task task, int i) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new ListTile(
            leading: new CircleAvatar(
              backgroundColor: KorePrimaryColor,
              child: new Text((i + 1).toString()),
              foregroundColor: Colors.white,
            ),
            trailing: Icon(completeIcon),
            title: new Text(task.description),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskDetail(
                        task: task,
                        userRepository: widget.userRepository,
                        role: widget.role,
                        updatePercentCallBack: _updatePercentageIndicator),
                  ));
            },
          ),
        ),
      ],
    );

  }

  void markCompleted(Task task) {
    setState(() {
      task.setStatus(_api, _token, task);
    });
    setState(() {
      _percent =
          _api.getPercentageOfTasksCompleted(_token, _user, widget.account);
    });
    _buildHeader();
  }

  void markNotCompleted(Task task) {
    setState(() {
      task.setStatus(_api, _token, task);
    });
    setState(() {
      _percent =
          _api.getPercentageOfTasksCompleted(_token, _user, widget.account);
    });
    _buildHeader();
  }
}

class AccountDetail extends StatefulWidget {
  final Account account;
  final UserRepository userRepository;
  final String role;
  const AccountDetail(
      {Key key,
      @required this.account,
      @required this.userRepository,
      @required this.role})
      : assert(userRepository != null),
        assert(role != null),
        super(key: key);

  @override
  AccountDetailState createState() => new AccountDetailState();
}
