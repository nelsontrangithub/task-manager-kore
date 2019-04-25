import 'package:kore_app/models/task.dart';

class Account {
  String title;
  bool isCompleted;
  double percentage;
  List<Task> taskList;
  Account(this.title, this.isCompleted, this.percentage, this.taskList);
}