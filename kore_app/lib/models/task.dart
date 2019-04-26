import 'package:flutter/material.dart';

class Task {
  int ownerId;
  int taskStatus;
  String description;
  DateTime dueDate;
  DateTime  completedOn;
  String subject;
  int department;
  int id;
  int taskId;
  int accountId;
  int userId;
  int orgId;
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
    this.ownerId,
    this.taskStatus,
    this.description,
    this.dueDate,
    this.completedOn,
    this.subject,
    this.department,
    this.id,
    this.taskId,
    this.accountId,
    this.userId,
    this.orgId,
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

    factory Task.fromJson(Map<String, dynamic> json ) {
    return new Task(
        ownerId: json['ownerId'] as int,
        taskStatus: json['taskStatus'] as int,
        description: json['description'] as String,
        dueDate: json['dueDate'] as DateTime,
        completedOn: json['completedOn'] as DateTime,
        subject: json['subject'] as String,
        department: json['department'] as int,
        id: json['id'] as int,
        taskId: json['taskId'] as int,
        accountId: json['accountId'] as int,
        userId: json['userId'] as int,
        orgId: json['orgId'] as int,
        dateCreated: json['dateCreated'] as DateTime,
        dateModified: json['dateModified'] as DateTime,
        status: json['status'] as int,
        createdBy: json['createdBy'] as int,
        modifiedBy: json['modifiedBy'] as int,
    );
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
