import 'package:flutter/material.dart';
import '../widgets/forms_inputs/image.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/forms_inputs/location.dart';
import '../models/location_data.dart';
import 'dart:io';

class ProductEditPage extends StatefulWidget {
  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': null,
    'location': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }

  GestureDetector _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
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
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(
                height: 10.0,
              ),
              LocationInput(_setLocation, product),
              SizedBox(
                height: 10.0,
              ),
              ImageInput(_setImage, product),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(),
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
  }

  void _setLocation(LocationData locData) {
    _formData['location'] = locData;
  }

  void _setImage(File image) {
    _formData['image'] = image;
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RaisedButton(
                child: Text('Save'),
                textColor: Colors.white,
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectedProductIndex,
                    model.selectProduct),
              );
      },
    );
  }

  _submitForm(Function addProduct, Function updateProduct,
      int selectedProductIndex, Function setSelectedProduct) {
    if (!_formKey.currentState.validate() ||
        (_formData['image'] == null && selectedProductIndex == -1)) {
      return;
    }
    _formKey.currentState.save();

    if (selectedProductIndex == -1) {
      addProduct(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        _formData['price'],
        _formData['location'],
      ).then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext builder) {
                return AlertDialog(
                  title: Text('Something went wrong'),
                  content: Text('Please try again'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });
    } else {
      updateProduct(
        _titleTextController.text,
        _descriptionTextController.text,
        _formData['image'],
        _formData['price'],
        _formData['location'],
      ).then((_) {
        Navigator.pushReplacementNamed(context, '/products')
            .then((_) => setSelectedProduct(null));
      });
    }
  }

  Widget _buildPriceTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Product price'),
      initialValue: product == null ? '' : product.price.toString(),
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

  Widget _buildDescriptionTextField(Product product) {
    if (product == null && _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else if (product != null &&
        _descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = product.description;
    }

    return TextFormField(
      decoration: InputDecoration(labelText: 'Product description'),
      // initialValue: product == null ? '' : product.description,
      controller: _descriptionTextController,
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

  Widget _buildTitleTextField(Product product) {
    if (product == null && _titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else if (product != null && _titleTextController.text.trim() == '') {
      _titleTextController.text = product.title;
    } else if (product != null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else if (product == null && _titleTextController.text.trim() != '') {
      _titleTextController.text = _titleTextController.text;
    } else {
      _titleTextController.text = '';
    }

    return TextFormField(
      decoration: InputDecoration(labelText: 'Product Title'),
      // initialValue: product == null ? '' : product.title,
      controller: _titleTextController,
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
