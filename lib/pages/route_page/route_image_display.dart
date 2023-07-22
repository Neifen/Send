import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/components/my_loader.dart';
import 'package:send/database/route_data.dart';
import 'package:send/provider/selected_router_provider.dart';

class RouteImageDisplay extends ConsumerWidget {
  const RouteImageDisplay({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteData route = getSelectedRoute(ref);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: MyLoader(
            future: route.getBestPathForPhoto(),
            builder: (context, snapshot) {
              return Container(
                  decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: const BorderRadius.all(Radius.circular(20))),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      child: InteractiveViewer(
                        maxScale: 5,
                        child: snapshot.hasData
                            ? Image.network(
                                snapshot.data!,
                                height: 400,
                                gaplessPlayback: true,
                              )
                            : const Icon(Icons.error),
                      )));
            }));
  }
}
