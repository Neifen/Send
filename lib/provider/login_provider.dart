import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier {
  LoginProvider() {
    login(true);
  }
  bool loggedIn = false;

  login(bool change) {
    loggedIn = change;
    notifyListeners();
  }
}
