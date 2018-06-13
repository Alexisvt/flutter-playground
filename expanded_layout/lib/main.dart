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
              Padding(
                child: Text('Images Demo'),
                padding: EdgeInsets.all(10.0),
              ),
              new Expanded(
                  child: Image
                      .asset('images/CMS_Creative_164657191_Kingfisher.jpg')),
              new Expanded(
                  child:
                      Image.network('http://voidrealms.com/images/smile.jpg')),
            ],
          ),
        ),
      ),
    );
  }
}
