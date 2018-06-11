import 'package:flutter/material.dart';

main(List<String> args) {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<BottomNavigationBarItem> _items;
  String _value = '';
  int _index = 0;

  @override
  void initState() {
    _items = List();
    _items.add(BottomNavigationBarItem(
        icon: Icon(Icons.people), title: Text('People')));
    _items.add(BottomNavigationBarItem(
        icon: Icon(Icons.weekend), title: Text('Weekend')));
    _items.add(BottomNavigationBarItem(
        icon: Icon(Icons.message), title: Text('Message')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name here'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            children: <Widget>[Text(_value)],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        fixedColor: Colors.blue,
        currentIndex: _index,
        onTap: (int item) => setState(() {
              _index = item;
              _value = 'Current value is: ${_index.toString()}';
            }),
      ),
    );
  }
}
