import 'package:flutter/material.dart';
import 'contract.dart';

class ContractListState extends State<ContractList> {
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
    body: _buildList(),
  );
  }
  Widget _buildProfileRow() {
    return Container(
      
    );
  }
  Widget _buildList() {
    /*dummy data*/
    _contracts.add(Contract("Contract 1", false));
    _contracts.add(Contract("Contract 2", false));
    _contracts.add(Contract("Contract 3", true));
    _contracts.add(Contract("Contract 4", false));
    _contracts.add(Contract("Contract 5", false));
    _contracts.add(Contract("Contract 6", false));
    _contracts.add(Contract("Contract 7", true));
    _contracts.add(Contract("Contract 8", false));
    _contracts.add(Contract("Contract 9", false));
    _contracts.add(Contract("Contract 10", false));
    _contracts.add(Contract("Contract 11", true));
    _contracts.add(Contract("Contract 12", false));
  return ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(); 

        final index = i ~/ 2; 
        
        return _buildRow(_contracts[index]);
      });
}

Widget _buildRow(Contract contract) {
  return ListTile(
    title: Text(
      contract.title,
      style: _biggerFont,
    ),
    trailing: Icon(   // Add the lines from here... 
      contract.isCompleted ? Icons.done : null,
    ), 
    onTap: () { 
      setState(() {
      contract.isCompleted = !contract.isCompleted;
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
  ContractListState createState() => new ContractListState();
}