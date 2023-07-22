import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/database/route_data.dart';
import 'package:send/pages/add_route/add_edit_route_page.dart';
import 'package:send/pages/route_page/route_rating_display.dart';
import 'package:send/pages/route_page/route_image_display.dart';
import 'package:send/pages/route_page/route_send_counter.dart';
import 'package:send/provider/login_provider.dart';
import 'package:send/provider/selected_router_provider.dart';

class RoutePage extends ConsumerWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteData route = getSelectedRoute(ref);

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      )),
      floatingActionButton: ref.watch(loginProvider.notifier).isAuthor(route)
          ? FloatingActionButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditRoutePage())),
              child: const Icon(Icons.edit),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Image
              const RouteImageDisplay(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Grading
                  Container(
                    decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
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
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...route.getTags().map((e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Chip(label: Text(e)),
                            ))
                      ],
                    ),
                  ),
                  // Rating
                  const RouteRatingDisplay(),
                  // Send Counter
                  const RouteSendCounter(),
                  // Comments
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                        decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.all(Radius.circular(20))),
                        padding: const EdgeInsets.all(8.0),
                        child: const Text('Comments:', style: TextStyle(fontWeight: FontWeight.bold))),
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
