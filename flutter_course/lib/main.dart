import 'package:flutter/material.dart';
import 'package:flutter_course/helpers/custom_routes.dart';
import 'package:flutter_course/shared/adaptive_theme.dart';
import 'package:flutter_course/shared/global_config.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/rendering.dart';

import './pages/products.dart';
import './pages/products_admin.dart';
import './pages/product.dart';
import './pages/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
import './models/product.dart';
import 'package:map_view/map_view.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  MapView.setApiKey(apiKey);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  final _platformChannel = MethodChannel('flutter-course.com/battery');
  bool _isAuthenticated = false;

  Future<void> _getBatteryLevel() async {
    String batteryLevel;

    try {
      final int result = await _platformChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level is $result %.';
    } catch (error) {
      batteryLevel = 'Failed to get battery level.';
    }

    print(batteryLevel);
  }

  @override
  void initState() {
    _model.autoAthenticate();
    _model.userSubject.listen((dynamic isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    _getBatteryLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        title: 'EasyList',
        theme: getAdaptiveThemeData(context),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model),
        },
        onGenerateRoute: buildGenerateRoute,
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductsPage(_model));
        },
      ),
    );
  }

  Route buildGenerateRoute(RouteSettings settings) {
    if (!_isAuthenticated) {
      return MaterialPageRoute<bool>(
        builder: (BuildContext context) => AuthPage(),
      );
    }
    final List<String> pathElements = settings.name.split('/');

    if (pathElements[0] != '') {
      return null;
    }

    if (pathElements[1] == 'product') {
      final String productId = pathElements[2];
      final Product product =
          _model.allProducts.firstWhere((product) => product.id == productId);

      return CustomRoute<bool>(
          builder: (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductPage(product));
    }
    return null;
  }
}
