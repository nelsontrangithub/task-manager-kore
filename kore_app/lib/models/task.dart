import 'package:flutter/material.dart';

class Task {
  int id;
  String subject;
  int taskType;
  int department;
  String description;
  DateTime dueDate;
  DateTime  completedOn;
  DateTime dateCreated;
  DateTime dateModified;
  int status;
  int createdBy;
  int modifiedBy;
  bool isCompleted;
  Object color;
  Object icon;
  String label;

  Task({
    this.id,
    this.subject,
    this.taskType,
    this.department,
    this.description,
    this.dueDate,
    this.completedOn,
    this.dateCreated,
    this.dateModified,
    this.status,
    this.createdBy,
    this.modifiedBy,
    })

  {
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
