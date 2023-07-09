import 'package:flutter/material.dart';
import 'package:send/database/route_data.dart';
import 'package:send/services/route_service.dart';

class RouteSendCounter extends StatefulWidget {
  final RouteData route;
  final RouteService overviewService;
  const RouteSendCounter({super.key, required this.route, required this.overviewService});

  @override
  State<RouteSendCounter> createState() => _RouteSendCounterState();
}

class _RouteSendCounterState extends State<RouteSendCounter> {
  int sentCount = 0;
  bool hasSent = false;

  @override
  Widget build(BuildContext context) {
    sentCount = widget.route.getSentCount();
    hasSent = widget.route.hasUserSent('Nate');

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
                  onPressed: () async {
                    Map counterMap = await widget.overviewService.changeSentCount(widget.route.id, 'Nate');
                    setState(() {
                      widget.route.setSentCounter(counterMap);
                    });
                  },
                  child: Text(hasSent ? 'Nvm...' : 'Sent!'))
            ],
          ),
        ));
  }
}
