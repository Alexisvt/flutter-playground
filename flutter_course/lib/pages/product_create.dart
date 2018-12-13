import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String titleValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: (String value) {
            setState(() {
              titleValue = value;
            });
          },
        ),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          onChanged: (String value) {},
        ),
      ],
    );
  }
}
