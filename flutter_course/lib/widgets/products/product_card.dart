import 'package:flutter/material.dart';
import './price_tag.dart';
import '../ui_elements/title_default.dart';
import './address_tag.dart';
import '../../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scoped-models/main.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int productIndex;

  ProductCard(this.product, this.productIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(product.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/image_placeholder.png'),
          ),
          _buildTitlePriceRow(),
          AddressTag('Union Square, San Francisco'),
          Text(product.userEmail),
          _buildActionButtons(context)
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/product/' + model.allProducts[productIndex].id),
            color: Theme.of(context).accentColor,
          ),
          IconButton(
            icon: Icon(model.allProducts[productIndex].isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              model.selectProduct(model.allProducts[productIndex].id);
              model.toggleProductFavoriteStatus();
            },
            color: Colors.red,
          )
        ],
      );
    });
  }

  Widget _buildTitlePriceRow() {
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleDefault(product.title),
            SizedBox(
              width: 10.0,
            ),
            ProductTag(product.price.toString())
          ],
        ));
  }
}
