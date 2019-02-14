import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/location_data.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import '../models/auth.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:rxdart/subjects.dart';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selProductId;
  bool _isLoading = false;
}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts => List.from(_products);

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  bool get displayFavoritesOly => _showFavorites;

  String get selectedProductId => _selProductId;

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }

    return _products.firstWhere((product) => product.id == _selProductId);
  }

  int get selectedProductIndex =>
      _products.indexWhere((product) => product.id == _selProductId);

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://us-central1-flutter-products-d86a0.cloudfunctions.net/storeImage'),
    );
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );

    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something went wrong');
        print(json.decode(response.body));
        return null;
      }

      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProduct(
    String title,
    String description,
    File image,
    double price,
    LocationData locData,
  ) async {
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);

    if (uploadData == null) {
      print('Upload failed');
      return false;
    }

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
    };
    try {
      final http.Response response = await http.post(
          'https://flutter-products-d86a0.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
        id: responseData['name'],
        title: title,
        description: description,
        image: uploadData['imageUrl'],
        imagePath: uploadData['imagePath'],
        price: price,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
        location: locData,
      );

      _products.add(newProduct);
      _selProductId = null;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
    String title,
    String description,
    File image,
    double price,
    LocationData locData,
  ) async {
    _isLoading = true;
    notifyListeners();

    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);

      if (uploadData == null) {
        print('Upload failed');
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address,
    };

    try {
      final http.Response response = await http.put(
          'https://flutter-products-d86a0.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));

      _isLoading = false;

      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: title,
        description: description,
        image: imageUrl,
        imagePath: imagePath,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        location: locData,
      );

      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutter-products-d86a0.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
        .then((response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts({onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://flutter-products-d86a0.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((response) {
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((productId, productData) {
        final Product product = Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          image: productData['imageUrl'],
          imagePath: productData['imagePath'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
          location: LocationData(
              latitude: productData['loc_lat'],
              longitude: productData['loc_lng'],
              address: productData['loc_address']),
          isFavorite: productData['wishlistUsers'] == null
              ? false
              : (productData['wishlistUsers'] as Map<String, dynamic>)
                  .containsKey(_authenticatedUser.id),
        );
        fetchedProductList.add(product);
      });

      _products = onlyForUser
          ? fetchedProductList
              .where(
                  (Product product) => product.userId == _authenticatedUser.id)
              .toList()
          : fetchedProductList;

      _isLoading = false;
      notifyListeners();
      _selProductId = null;
      return;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    http.Response response;

    final Product updatedProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      isFavorite: newFavoriteStatus,
      image: selectedProduct.image,
      imagePath: selectedProduct.imagePath,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      location: selectedProduct.location,
    );

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();

    if (newFavoriteStatus) {
      response = await http.put(
          'https://flutter-products-d86a0.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
        'https://flutter-products-d86a0.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
      );
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      // We re rolling back the changes in case something wrog happened while updating
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        // rolling back the changes because something fails on the server
        isFavorite: isCurrentlyFavorite,
        image: selectedProduct.image,
        imagePath: selectedProduct.imagePath,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        location: selectedProduct.location,
      );

      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void selectProduct(String productId) {
    _selProductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

mixin UsersModel on ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  PublishSubject get userSubject => _userSubject;

  User get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    http.Response response;

    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCBCMHrJVx2QfcHjnwtcjEHEu_73USQqDE',
          body: json.encode(authData),
          headers: {
            'Content-Type': 'application/json',
          });
    } else if (mode == AuthMode.Signup) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCBCMHrJVx2QfcHjnwtcjEHEu_73USQqDE',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';

    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication successed!';
      _authenticatedUser = User(
        id: responseData['localId'],
        email: email,
        token: responseData['idToken'],
      );

      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);

      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    }

    _isLoading = false;
    notifyListeners();

    return {
      'success': !hasError,
      'message': message,
    };
  }

  autoAthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.get('expiryTime');

    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);

      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }

      _authenticatedUser = User(
        id: prefs.getString('userId'),
        email: prefs.getString('userEmail'),
        token: token,
      );
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
