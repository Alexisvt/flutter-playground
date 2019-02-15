import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/ui_elements/adapative_progress_indicator.dart';

import '../widgets/products/products.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        title: Text('EasyList'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildProductsList(),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
          child: Text('No Product Found!'),
        );

        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(child: AdapativeProgressIndicator());
        }

        return RefreshIndicator(
          child: content,
          onRefresh: model.fetchProducts,
        );
      },
    );
  }

  Drawer _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
            automaticallyImplyLeading: false,
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          LogoutListTile(),
        ],
      ),
    );
  }
}
