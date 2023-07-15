import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:send/database/route_data.dart';
import 'package:send/services/route_service.dart';

class RouteRatingDisplay extends StatefulWidget {
  final RouteData route;
  final RouteService overviewService;
  const RouteRatingDisplay({super.key, required this.route, required this.overviewService});

  @override
  State<RouteRatingDisplay> createState() => _RouteRatingDisplayState();
}

class _RouteRatingDisplayState extends State<RouteRatingDisplay> {
  @override
  Widget build(BuildContext context) {
    String currentRating = widget.route.getRating();
    return Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Text('Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(currentRating),
              ),
              RatingBar.builder(
                  minRating: 1,
                  initialRating: widget.route.getUserRating('Nate'),
                  itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                  onRatingUpdate: (value) async {
                    Map newRating = await widget.overviewService.changeRating(widget.route.id, value, 'Nate');
                    setState(() {
                      widget.route.setRating(newRating);
                    });
                  })
            ],
          ),
        ));
  }
}
