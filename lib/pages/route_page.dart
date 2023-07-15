import 'package:flutter/material.dart';
import 'package:send/database/route_data.dart';
import 'package:send/pages/add_route/add_route_page.dart';
import 'package:send/pages/route_page/route_rating_display.dart';
import 'package:send/pages/route_page/route_image_display.dart';
import 'package:send/pages/route_page/route_send_counter.dart';
import 'package:send/services/route_service.dart';

class RoutePage extends StatefulWidget {
  final RouteData initRoute;
  const RoutePage(this.initRoute, {super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late RouteData route;
  bool updated = false;

  @override
  void initState() {
    super.initState();
    route = widget.initRoute;
  }

  @override
  Widget build(BuildContext context) {
    final overviewService = RouteService();

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context, updated),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditRoutePage(routeData: route))).then((value) {
          if (value == null) return;
          setState(() {
            route = value;
            updated = true;
          });
        }),
        child: const Icon(Icons.edit),
      ),
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
