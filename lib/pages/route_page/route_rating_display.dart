import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/database/route_data.dart';
import 'package:send/provider/selected_router_provider.dart';

class RouteRatingDisplay extends ConsumerWidget {
  const RouteRatingDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteData route = getSelectedRoute(ref);

    String currentRating = route.getRating();
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
                  initialRating: route.getUserRating('Nate'),
                  itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                  onRatingUpdate: (value) {
                    ref.read(selectedRoute.notifier).setRating(value);
                  })
            ],
          ),
        ));
  }
}
