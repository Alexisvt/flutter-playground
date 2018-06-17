import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;

  List<Widget> _list = new List<Widget>();

  @override
  void initState() {
    for (var i = 0; i < 5; ++i) {
      Widget child = _newItem(i);
      _list.add(child);
    }
    super.initState();
  }

  void _onClicked() {
    Widget child = _newItem(counter);
    setState(() {
      _list.add(child);
    });
  }

  Widget _newItem(int i) {
    Key key = Key('item $i');

    counter++;
    return Container(
      key: key,
      padding: EdgeInsets.all(10.0),
      child: Chip(
        label: Text('$i Name here'),
        deleteIconColor: Colors.red,
        deleteButtonTooltipMessage: 'Delete',
        onDeleted: () => _removeItem(key),
        avatar: CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          child: Text(i.toString()),
        ),
      ),
    );
  }

  void _removeItem(Key key) {
    for (var i = 0; i < _list.length; ++i) {
      Widget child = _list.elementAt(i);
      if (child.key == key) {
        setState(() {
          _list.removeAt(i);
          print('Removing ${key.toString()}');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chip sample'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onClicked,
        child: Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: _list,
          ),
        ),
      ),
    );
  }
}
