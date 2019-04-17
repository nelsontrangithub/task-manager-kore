import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// the root widget of our application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Team Sponsor T-Shirts"),
        ),
        body: _buildList(),
      ),
    );
  }
}

// Hard-coded example list
Widget _buildList() => ListView(
      children: [
        _tile('Design Logo', 'subtitle', Icons.done_outline),
        _tile('Purchase T-Shirts, Recieve Delivery', '25S 50M 25L',
            Icons.done_outline),
        Divider(),
        _tile('Deliver Shirts to Partner', '2550 Mi', Icons.timelapse),
      ],
    );

ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          )),
      subtitle: Text(subtitle),
      trailing: Icon(
        icon,
        color: Colors.green[500],
      ),
    );
