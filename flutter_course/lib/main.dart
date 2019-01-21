import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

import './pages/products.dart';
import './pages/products_admin.dart';
import './pages/product.dart';
import './pages/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
import './models/product.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepPurple,
        ),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/admin': (BuildContext context) => ProductsAdminPage(model),
          '/products': (BuildContext context) => ProductsPage(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');

          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'product') {
            final String productId = pathElements[2];
            final Product product = model.allProducts
                .firstWhere((product) => product.id == productId);

            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(model));
        },
      ),
    );
  }
}
