import 'package:flutter/material.dart';

import './product_control.dart';
import './products.dart';

class ProductManager extends StatefulWidget {
  final Map<String, String> startingProduct;

  ProductManager({this.startingProduct});

  @override
  _ProductManagerState createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
  final List<Map<String, String>> _products = [];

  @override
  void initState() {
    super.initState();
    if (widget.startingProduct != null) {
      _products.add(widget.startingProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: ProductControl(_addProduct),
        ),
        Expanded(child: Products(_products))
      ],
    );
  }

  void _addProduct(Map<String, String> product) {
    setState(() {
      _products.add(product);
    });
  }
}
