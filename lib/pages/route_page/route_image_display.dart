import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:send/components/my_loader.dart';
import 'package:send/database/route_data.dart';
import 'package:send/services/route_service.dart';

class RouteImageDisplay extends StatefulWidget {
  final RouteData route;
  final RouteService overviewService;
  const RouteImageDisplay({super.key, required this.route, required this.overviewService});

  @override
  State<RouteImageDisplay> createState() => _RouteImageDisplayState();
}

class _RouteImageDisplayState extends State<RouteImageDisplay> {
  late Future<Uint8List?> imageBytes;

  @override
  void initState() {
    super.initState();

    Future<Uint8List?> fullImage = widget.overviewService.getFullImage(widget.route.getPhoto());
    imageBytes = widget.route.image;

    fullImage.then((value) {
      setState(() {
        imageBytes = imageBytes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: MyLoader(
            future: imageBytes,
            builder: (context, snapshot) {
              return Container(
                  decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: const BorderRadius.all(Radius.circular(20))),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(18)),
                      child: InteractiveViewer(
                        maxScale: 5,
                        child: snapshot.hasData
                            ? Image.memory(
                                snapshot.data!,
                                height: 400,
                                gaplessPlayback: true,
                              )
                            : const Icon(Icons.error),
                      )));
            }));
  }
}
