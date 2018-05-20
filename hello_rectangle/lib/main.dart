// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class HelloRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        color: Colors.greenAccent,
        height: 400.0,
        width: 300.0,
        child: Center(
          child: Text(
            'Hola!',
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ),
    );
  }
}

void main() {
  print('Hello!');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hola mundo rectangle'),
        ),
        body: HelloRectangle(),
      )
  )
  );
}
