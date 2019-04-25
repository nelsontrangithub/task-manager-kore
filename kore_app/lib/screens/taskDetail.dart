import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kore_app/models/task.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/utils/theme.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../utils/theme.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;


class TaskDetailState extends State<TaskDetail> {
  final _user = User("Tina",
      "https://image.flaticon.com/icons/png/128/201/201570.png", "satus");

  var text;
  var textcolor;

  initState() {
    super.initState();
    print(widget.task.isCompleted);
    if (widget.task.isCompleted == true) {
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
      body: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              _buildHeader(),
              _buildCalendar(widget.task),
              _buildTaskDescription(),
              _buildTaskEnd()
              //  _buildTaskEnd(widget.task),
            ],
          ),
        ],
      ),
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
              // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: new CachedNetworkImage(
                imageUrl: _user.iconUrl,
              ),
            ),
          ),
          Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.task.title,
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
                    'Id: ' + widget.task.id.toString(),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(Task task) {

    

    return Container(
        child: Card(
          elevation: 0,
          child: CalendarCarousel(
            viewportFraction: 0.5,
            dayPadding: 5,	
            height: 380,
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
            todayTextStyle: TextStyle(
              fontSize: 20
            ),
            selectedDayTextStyle: TextStyle(
              fontSize: 20
            ),
            todayButtonColor: KorePrimaryColor,
            selectedDateTime: widget.task.dueDate,
            selectedDayButtonColor: Colors.red,
          ),
        ));
  }

  Widget _buildTaskDescription() {
    return new Container(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Card(
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
              subtitle: Text(
                widget.task.description,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
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
      elevation: 4.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff1282c5),
      child: MaterialButton(
        minWidth: 100,
        onPressed: () {},
        child: Text(
          'Upload File',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return Material(
      elevation: 4.0,
      shape: CircleBorder(side: BorderSide.none),
      color: Color(0xff1282c5),
      child: MaterialButton(
          minWidth: 100,
          onPressed: () {
            showAlertDialog(context);
          },
          child: Icon(
            Icons.check,
            color: Colors.white,
          )),
    );
  }

  // Widget _buildTaskEnd(Task task) {
  //   var now = widget.task.dueDate;
  //   var formatter = new DateFormat('yyyy-MM-dd');
  //   String formatted = formatter.format(now);

  //   void toggleCompleted(Task task) {
  //     task.isCompleted = !task.isCompleted;
  //     setState(() {
  //       if (task.isCompleted == true) {
  //         text = 'Status: Not Complete';
  //         textcolor = Colors.redAccent;
  //       } else {
  //         text = 'Status: Complete';
  //         textcolor = Colors.green[800];
  //       }
  //       task.setStatus();
  //     });
  //   }

  //   return new Container(
  //     padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
  //     child: Card(
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: <Widget>[
  //           ListTile(
  //             leading: Icon(Icons.file_upload, color: KorePrimaryColor),
  //             title: Text("Date created: " + formatted),
  //             subtitle: Text('Date due: ' + formatted),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
      child: Text("Done!!"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Notice"),
      content: Text("Would you like to confirm the task?"),
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

  const TaskDetail({Key key, this.task}) : super(key: key);

  @override
  TaskDetailState createState() => new TaskDetailState();
}
