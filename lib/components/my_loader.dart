import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class MyLoader extends StatelessWidget {
  final Future future;
  final Widget child;
  final Widget? alternative;
  const MyLoader({super.key, required this.future, required this.child, this.alternative});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => snapshot.hasData ? child : alternative ?? const CircularProgressIndicator(),
    );
    ;
  }
}
