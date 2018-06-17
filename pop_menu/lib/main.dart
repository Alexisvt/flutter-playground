import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum Animals { Cat, Dob, Bird, Lizard, Fish }

class _MyAppState extends State<MyApp> {
  Animals _selected = Animals.Cat;
  String _value = 'Make a Selection';
  List<PopupMenuEntry<Animals>> _items = List<PopupMenuEntry<Animals>>();

  @override
  void initState() {
    super.initState();
    for (var animal in Animals.values) {
      _items.add(PopupMenuItem(
        child: Text(_getDisplay(animal)),
        value: animal,
      ));
    }
  }

  void _onSelected(Animals animal) {
    setState(() {
      _selected = animal;
      _value = 'You Selected ${_getDisplay(animal)}';
    });
  }

  String _getDisplay(Animals animal) {
    int index = animal.toString().indexOf('.');
    index++;
    return animal.toString().substring(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PopUp Menu Button sample'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                child: Text(_value),
              ),
              PopupMenuButton<Animals>(
                child: Icon(Icons.input),
                initialValue: Animals.Cat,
                onSelected: _onSelected,
                itemBuilder: (BuildContext context) {
                  return _items;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
