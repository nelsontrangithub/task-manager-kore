import 'package:kore_app/models/task.dart';

class Contract {
  String title;
  bool isCompleted;
  double percentage;
  List<Task> taskList;
  Contract(this.title, this.isCompleted, this.percentage, this.taskList);
}