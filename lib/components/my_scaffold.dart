import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send/pages/welcome_page.dart';
import 'package:send/provider/login_provider.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  const MyScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, login, _) {
      return login.loggedIn ? child : const WelcomePage();
    });
  }
}
