import 'package:flutter/material.dart';

class Task {
  int id;
  String title;
  bool isCompleted;
  String description;
  DateTime dueDate;
  DateTime dateCreated;
  int status;
  Object color;
  Object icon;
  String label;

  //Task(this.id, this.title, this.isCompleted, this.description, this.dueDate, this.color, this.icon, this.label);

  Task(int id, String title, bool isCompleted, String description,
      DateTime dueDate) {
    this.id = id;
    this.title = title;
    this.isCompleted = isCompleted;
    this.description = description;
    this.dueDate = dueDate;

    if (isCompleted == true) {
      this.color = Colors.green[800];
      this.icon = Icons.done;
      this.label = "Complete";
    } else {
      this.color = Colors.red[800];
      this.icon = Icons.cancel;
      this.label = "Not Complete";
    }
  }

  void setStatus(){
    if (isCompleted == true) {
      this.color = Colors.green[800];
      this.icon = Icons.done;
      this.label = "Complete";
    } else {
      this.color = Colors.red[800];
      this.icon = Icons.cancel;
      this.label = "Not Complete";
    }
  }
}
