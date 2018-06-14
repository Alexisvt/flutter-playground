import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

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
  Map _countries = Map();

  void _getData() async {
    var url = 'http://country.io/names.json';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _countries = JSON.decode(response.body);
        print('Loaded ${_countries.length} countries');
      });
    }
  }

  @override
  void initState() {
    _getData();
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
            children: <Widget>[
              Text(
                'Countries',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _countries.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = _countries.keys.elementAt(index);
                    return Row(children: <Widget>[
                      Text('$key: '),
                      // Text(_countries[key])
                    ]);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
