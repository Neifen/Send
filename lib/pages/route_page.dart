import 'package:flutter/material.dart';
import 'package:send/database/route_data.dart';
import 'package:send/pages/route_page/route_rating_display.dart';
import 'package:send/pages/route_page/route_image_display.dart';
import 'package:send/pages/route_page/route_send_counter.dart';
import 'package:send/services/route_service.dart';

class RoutePage extends StatelessWidget {
  final RouteData route;
  const RoutePage(this.route, {super.key});

  @override
  Widget build(BuildContext context) {
    final overviewService = RouteService();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Image
              RouteImageDisplay(route: route, overviewService: overviewService),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text('Grading', style: TextStyle(fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(route.getGrade()),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Rating
                  RouteRatingDisplay(route: route, overviewService: overviewService),
                  // Send Counter
                  RouteSendCounter(route: route, overviewService: overviewService),
                  // Comments
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                        decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.all(Radius.circular(20))),
                        child: const Padding(
                          //todo
                          padding: EdgeInsets.all(8.0),
                          child: Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold)),
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
