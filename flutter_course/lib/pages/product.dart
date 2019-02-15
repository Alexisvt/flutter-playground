import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/products/product_fab.dart';
import 'package:map_view/map_view.dart';
import '../models/product.dart';
import '../widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
//        print('back button pressed');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Hero(
                  tag: product.id,
                  child: FadeInImage(
                    image: NetworkImage(product.image),
                    height: 300.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/image_placeholder.png'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: TitleDefault(product.title),
                  ),
                  _buildAddressPriceRow(
                    product.location.address,
                    product.price,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: ProductFAB(product),
      ),
    );
  }

  void _showMap() {
    final markers = <Marker>[
      Marker('position', 'Position', product.location.latitude,
          product.location.longitude)
    ];
    final cameraPosition = CameraPosition(
      Location(product.location.latitude, product.location.longitude),
      4.0,
    );
    final mapView = MapView();
    mapView.show(
        MapOptions(
            mapViewType: MapViewType.normal,
            title: 'Product Location',
            initialCameraPosition: cameraPosition),
        toolbarActions: [
          ToolbarAction('Close', 1),
        ]);

    mapView.onToolbarAction.listen(
      (int id) {
        if (id == 1) {
          mapView.dismiss();
        }
      },
    );
    mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
    });
  }

  Widget _buildAddressPriceRow(String address, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _showMap,
          child: Text(
            address,
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$${price.toString()}',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
      ],
    );
  }
}
