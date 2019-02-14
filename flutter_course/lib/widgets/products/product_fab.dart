import 'package:flutter/material.dart';

class ProductFAB extends StatefulWidget {
  @override
  _ProductFABState createState() => _ProductFABState();
}

class _ProductFABState extends State<ProductFAB> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).cardColor,
            heroTag: 'contact',
            mini: true,
            onPressed: () {},
            child: Icon(
              Icons.mail,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 56.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).cardColor,
            heroTag: 'favorite',
            mini: true,
            onPressed: () {},
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ),
        Container(
          height: 70.0,
          width: 56.0,
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}
