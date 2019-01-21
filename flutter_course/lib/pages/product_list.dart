import 'package:flutter/material.dart';
import './product_edit.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (BuildContext builder, int index) {
                  return Dismissible(
                    // we need to use an unique value, this title is for demo porpuse
                    key: Key(model.allProducts[index].title),
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        model.selectProduct(model.allProducts[index].id);
                        model.deleteProduct();
                      }
                    },
                    background: Container(
                      color: Colors.red,
                    ),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(model.allProducts[index].image),
                          ),
                          title: Text(model.allProducts[index].title),
                          subtitle: Text(
                              '\$${model.allProducts[index].price.toString()}'),
                          trailing: _buildEditButton(context, index, model),
                        ),
                        Divider()
                      ],
                    ),
                  );
                },
                itemCount: model.allProducts.length,
              );
      },
    );
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(model.allProducts[index].id);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return ProductEditPage();
          },
        ));
      },
    );
  }
}
