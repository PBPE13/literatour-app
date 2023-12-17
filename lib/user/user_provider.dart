import 'package:flutter/material.dart';
import 'package:literatour_app/user/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(int id, String username) {
    _user = User(id: id, username: username);
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
