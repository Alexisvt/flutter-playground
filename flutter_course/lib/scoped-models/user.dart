import './connected_products.dart';
import '../models/user.dart';

mixin UsersModel on ConnectedProducts {
  void login(String email, String password) {
    authenticatedUser = User(id: '1213213', email: email, password: password);
  }
}
