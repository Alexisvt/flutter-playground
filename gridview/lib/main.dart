import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class Area {
  int index;
  String name;
  Color color;

  Area({this.index: -1, this.name: 'Area', this.color: Colors.lightBlueAccent});
}

class _MyAppState extends State<MyApp> {
  int _location;
  List<Area> _areas = List<Area>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 16; ++i) {
      _areas.add(Area(index: i, name: 'Area $i'));
    }

    var rng = Random();
    _location = rng.nextInt(_areas.length);
  }

  void _onPressed(int index) {
    setState(() {
      if (index == _location) {
        _areas[index].color = Colors.green;
      } else {
        _areas[index].color = Colors.red;
      }
    });
  }

  Widget _generate(int index) => GridTile(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: RaisedButton(
            onPressed: () => _onPressed(index),
            color: _areas[index].color,
            child: Text(
              _areas[index].name,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView sample'),
      ),
      body: Container(
        padding: EdgeInsets.all(32.0),
        child: Center(
          child: GridView.count(
            crossAxisCount: 4,
            children: List<Widget>.generate(16, _generate),
          ),
        ),
      ),
    );
    ;
  }
}
