import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/pages/welcome_page.dart';
import 'package:send/provider/login_provider.dart';

class MyScaffold extends StatelessWidget {
  final Widget child;
  const MyScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return ref.watch(loginProvider.notifier).isLoggedIn() ? child : const WelcomePage();
    });
  }
}
