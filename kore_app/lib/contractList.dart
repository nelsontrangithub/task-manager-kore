import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'contract.dart';
import 'data/user.dart';

class ContractListState extends State<ContractList> {
  final _contractStates = <ContractList>[];
  final _user = User("Tina", "https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
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
    body: new Column(children:<Widget>[_profileRow(), _buildList()]),
  );
  }
  Widget _profileRow() { 
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: new CachedNetworkImage(
        imageUrl: _user.iconUrl,
        placeholder: (context, url) => new CircularProgressIndicator(),
        errorWidget: (context, url, error) => new Icon(Icons.error),
     ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_user.name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(_user.status),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  @override
initState() {
  super.initState();

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
}

  Widget _buildList() {
  return Flexible(
    child: ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(); 

        final index = i ~/ 2; 
        if(_contracts.length>index){
        return _buildRow(_contracts[index]);
      }
      return null;
      }));
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