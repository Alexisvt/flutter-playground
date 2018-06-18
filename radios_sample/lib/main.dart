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
  int _value1 = 0;
  int _value2 = 0;

  void _setValue1(int value) {
    setState(() => _value1 = value);
  }

  void _setValue2(int value) {
    setState(() => _value2 = value);
  }

  Widget makeRadios() {
    List<Widget> list = List<Widget>();

    [1, 2, 3].forEach((i) {
      list.add(Radio(
        value: i,
        groupValue: _value1,
        onChanged: _setValue1,
      ));
    });

    Column column = Column(
      children: list,
    );
    return column;
  }

  Widget makeRadiosTiles() {
    List<Widget> list = List<Widget>();

    [1, 2, 3].forEach((i) {
      list.add(RadioListTile(
        value: i,
        groupValue: _value2,
        onChanged: _setValue2,
        activeColor: Colors.green,
        controlAffinity: ListTileControlAffinity.trailing,
        title: Text('Item: $i'),
        subtitle: Text('Subtitle'),
      ));
    });

    Column column = Column(
      children: list,
    );
    return column;
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
            children: [makeRadios(), makeRadiosTiles()],
          ),
        ),
      ),
    );
  }
}
