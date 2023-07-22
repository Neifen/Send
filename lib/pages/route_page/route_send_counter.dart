import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/database/route_data.dart';
import 'package:send/provider/selected_router_provider.dart';

class RouteSendCounter extends ConsumerWidget {
  const RouteSendCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteData route = getSelectedRoute(ref);

    int sentCount = route.getSentCount();
    bool hasSent = route.hasUserSent('Nate');

    return Container(
        decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text('Sends:', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('$sentCount'),
              ),
              OutlinedButton(
                  onPressed: () {
                    ref.read(selectedRoute.notifier).clickSent();
                  },
                  child: Text(hasSent ? 'Nvm...' : 'Sent!'))
            ],
          ),
        ));
  }
}
