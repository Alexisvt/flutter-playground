import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  _ProductCreatePageState createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  String titleValue = '';
  String descriptionValue = '';
  double priceValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Product Title'),
            onChanged: (String value) {
              setState(() {
                titleValue = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product description'),
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            onChanged: (String value) {
              descriptionValue = value;
            },
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Product price'),
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              priceValue = double.parse(value);
            },
          ),
          RaisedButton(child: Text('Save'), onPressed: () {
            final Map<String, dynamic> product = {
              'title': titleValue,
              'description': descriptionValue,
              'price': priceValue,
              'image': 'assets/food.jpg'
            };
            widget.addProduct(product);
          },)
        ],
      ),
    );
  }
}
