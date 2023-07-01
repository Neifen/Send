import 'package:flutter/material.dart';

class MyLoader extends StatelessWidget {
  final Future future;
  final Widget? alternative;
  final Function(BuildContext, AsyncSnapshot<dynamic>) builder;
  const MyLoader({super.key, required this.future, required this.builder, this.alternative});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) => snapshot.hasData ? Builder(builder: builder(context, snapshot)) : alternative ?? const CircularProgressIndicator(),
    );
    ;
  }
}
