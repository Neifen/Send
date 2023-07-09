import 'package:flutter/material.dart';

class MyLoader extends StatelessWidget {
  final Future future;
  final Widget? alternative;
  final AsyncWidgetBuilder<dynamic> builder;
  const MyLoader({super.key, required this.future, required this.builder, this.alternative});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('NO CONNECTION!');
          case ConnectionState.active:
          case ConnectionState.waiting:
            if (alternative != null) {
              return alternative!;
            }
            return const CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Text('ERROR!');
            }
            return Builder(builder: (_) => builder(context, snapshot));
        }
      },
    );
  }
}
