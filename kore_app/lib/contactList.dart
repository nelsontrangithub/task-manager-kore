import 'package:flutter/material.dart';
import 'contract.dart';

class ContactListState extends State<ContractList> {
  final _contractStates = <ContractList>[];
  final _contracts = <Contract>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // final Set<ContractInfo> _saved = Set<ContractInfo>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('Contract List'),
      // actions: <Widget>[      // Add 3 lines from here...
      //     IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
      //   ],
    ),
    body: _buildSuggestions(),
  );
  }

  Widget _buildSuggestions() {
  return ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(); 

        final index = i ~/ 2; 
        
        return _buildRow(_contracts[index]);
      });
}

Widget _buildRow(Contract contact) {
  return ListTile(
    title: Text(
      contact.title,
      style: _biggerFont,
    ),
    trailing: Icon(   // Add the lines from here... 
      contact.isCompleted ? Icons.favorite : Icons.favorite_border,
      color: contact.isCompleted ? Colors.red : null,
    ), 
    onTap: () {      // Add 9 lines from here...
      setState(() {
        // if (contact.isCompleted) {
        //   _saved.remove(pair);
        // } else { 
        //   _saved.add(pair); 
        // } 
      });
    }, 
  );
}
}

class ContractList extends StatefulWidget {
  @override
  ContactListState createState() => new ContactListState();
}