import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/database/route_data.dart';

final loginProvider = NotifierProvider<LoginProvider, String>(LoginProvider.new);

class LoginProvider extends Notifier<String> {
  login(String userName) {
    state = userName;
  }

  bool isLoggedIn() {
    return state.isNotEmpty;
  }

  bool isAuthor(RouteData route) {
    return route.getAuthor() == state;
  }

  String getUser() {
    return state;
  }

  @override
  String build() {
    return 'Nate';
  }
}
