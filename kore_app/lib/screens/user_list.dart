

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AsignTaskState extends State<AsignTask> {
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Asign Task"),
      ),
      body: new ListView() 
    );
  }
}

class AsignTask extends StatefulWidget {

  @override
  AsignTaskState createState() => new AsignTaskState();
}