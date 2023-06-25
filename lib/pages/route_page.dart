import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:send/components/my_scaffold.dart';

class RoutePage extends StatelessWidget {
  final String route;
  const RoutePage(this.route, {super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: "route: $route",
      child: Container(),
    );
  }
}
