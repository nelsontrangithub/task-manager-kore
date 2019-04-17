import 'package:flutter/material.dart';

class ContactListState extends State<ContractList> {
  final _contracts = <ContractList>[];
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
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(   // Add 20 lines from here...
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final List<Widget> divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();
          return Scaffold(         // Add 6 lines from here...
          appBar: AppBar(
            title: Text('Saved Suggestions'),
          ),
          body: ListView(children: divided),
        );
      },
    ), 
  );
  }

  Widget _buildSuggestions() {
  return ListView.builder(
      padding: const EdgeInsets.all(25.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(); 

        final index = i ~/ 2; 
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10)); /*4*/
        }
        return _buildRow(_suggestions[index]);
      });
}

Widget _buildRow(WordPair pair) {
  final bool alreadySaved = _saved.contains(pair);
  return ListTile(
    title: Text(
      pair.asPascalCase,
      style: _biggerFont,
    ),
    trailing: Icon(   // Add the lines from here... 
      alreadySaved ? Icons.favorite : Icons.favorite_border,
      color: alreadySaved ? Colors.red : null,
    ), 
    onTap: () {      // Add 9 lines from here...
      setState(() {
        if (alreadySaved) {
          _saved.remove(pair);
        } else { 
          _saved.add(pair); 
        } 
      });
    }, 
  );
}
}

class ContractList extends StatefulWidget {
  @override
  ContactListState createState() => new ContactListState();
}