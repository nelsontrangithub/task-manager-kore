import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kore_app/models/contract.dart';
import 'package:kore_app/models/user.dart';
import 'package:kore_app/screens/contractDetail.dart';

class ContractListState extends State<ContractList> {
  final _contractStates = <ContractList>[];
  final _user = User("Tina",
      "https://image.flaticon.com/icons/png/128/201/201570.png", "satus");
  final _contracts = <Contract>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _nameFont = const TextStyle(fontSize: 28.0);
  // final Set<ContractInfo> _saved = Set<ContractInfo>();

  //one of the state lifecycle function, only load once
  //good place for dummydata loading
  @override
  initState() {
    super.initState();

    /*dummy data*/
    _contracts.add(Contract("Contract 1", false, 20));
    _contracts.add(Contract("Contract 2", false, 50));
    _contracts.add(Contract("Contract 3", true, 100));
    _contracts.add(Contract("Contract 4", false, 40));
    _contracts.add(Contract("Contract 5", false, 50));
    _contracts.add(Contract("Contract 6", false, 60));
    _contracts.add(Contract("Contract 7", true, 70));
    _contracts.add(Contract("Contract 8", false, 80));
    _contracts.add(Contract("Contract 9", false, 100));
    _contracts.add(Contract("Contract 10", false, 100));
    _contracts.add(Contract("Contract 11", true, 100));
    _contracts.add(Contract("Contract 12", false, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract List'),
        // actions: <Widget>[      // Add 3 lines from here...
        //     IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        //   ],
      ),
      body: new Column(children: <Widget>[_profileRow(), _buildList()]),
    );
  }

  Widget _profileRow() {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 0.0),
      padding:const  EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black12,
      ),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Using expanded to ensure the image is always sized with contraint
          Expanded(
            child: new Container(
              height: 150.0,
              // margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: new CachedNetworkImage(
                imageUrl: _user.iconUrl,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_user.name, style: _nameFont),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(_user.status),
              ),
            ],
          ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Flexible(
        child: ListView.builder(
            padding: const EdgeInsets.all(25.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();

              final index = i ~/ 2;
              if (_contracts.length > index) {
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
      trailing: Icon(
        // Add the lines from here...
        contract.percentage>=100 ? Icons.done : null,
      ),
      onTap: () {
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => ContractDetail(contract: contract),));
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
  ContractListState createState() => new ContractListState();
}
