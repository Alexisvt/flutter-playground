import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(home: new MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class MyItem {
  bool isExpanded;
  final String header;
  final Widget body;

  MyItem(this.isExpanded, this.header, this.body);
}

class _MyAppState extends State<MyApp> {
  List<MyItem> _items = new List<MyItem>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 10; ++i) {
      _items.add(MyItem(
          false,
          'Item $i',
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text('Hello world'),
          )));
    }
  }

  ExpansionPanel _createItem(MyItem item) {
    return ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Container(
            padding: EdgeInsets.all(5.0),
            child: Text('Header ${item.header}'),
          );
        },
        body: item.body,
        isExpanded: item.isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expansion panel sample'),
      ),
      body: Container(
          padding: EdgeInsets.all(32.0),
          child: ListView(
            children: <Widget>[
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) => setState(
                    () => _items[index].isExpanded = !_items[index].isExpanded),
                children: _items.map(_createItem).toList(),
              )
            ],
          )),
    );
    ;
  }
}
