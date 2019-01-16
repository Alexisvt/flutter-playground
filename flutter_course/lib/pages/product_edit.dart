import 'package:flutter/material.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;

  ProductEditPage(
      {this.addProduct, this.updateProduct, this.product, this.productIndex});

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Widget pageContent = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(),
              _buildDescriptionTextField(),
              _buildPriceTextField(),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: _submitForm,
              ),
              // custom button
              // GestureDetector(
              //   onTap: _submitForm,
              //   child: Container(
              //     color: Colors.green,
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('My custom button'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );

    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );
  }

  _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (widget.product == null) {
      widget.addProduct(_formData);
    } else {
      widget.updateProduct(widget.productIndex, _formData);
    }
    _formKey.currentState.save();

    Navigator.pushReplacementNamed(context, '/products');
  }

  Widget _buildPriceTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product price'),
      initialValue:
          widget.product == null ? '' : widget.product['price'].toString(),
      validator: (String value) {
        // logic that validate the value
        // if there is no issue return null
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return "Price is required and should be a number";
        }
      },
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product description'),
      initialValue: widget.product == null ? '' : widget.product['description'],
      validator: (String value) {
        // logic that validate the value
        // if there is no issue return null
        if (value.isEmpty || value.length < 10) {
          return "Description is required and should be 10+ characters long.";
        }
      },
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      initialValue: widget.product == null ? '' : widget.product['title'],
      // autovalidate: true,
      validator: (String value) {
        // logic that validate the value
        // if there is no issue return null
        if (value.isEmpty || value.length < 5) {
          return "Title is required and should be 5+ characters long.";
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }
}