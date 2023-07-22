import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/database/route_data.dart';
import 'package:send/provider/route_list_provider.dart';
import 'package:send/services/route_service.dart';

final selectedRoute = ChangeNotifierProvider<SelectedRouterProvider>(((ref) => SelectedRouterProvider()));

RouteData getSelectedRoute(WidgetRef ref) {
  final optional = ref.watch(selectedRoute).state;
  if (optional == null) throw FlutterError('Route not selected internally');
  return optional;
}

class SelectedRouterProvider extends ChangeNotifier {
  late RouteService service;
  RouteData? state;
  selectRoute(RouteData data) {
    service = RouteService();
    state = data;
  }

  routePicked() {
    return state != null;
  }

  Future<void> clickSent() async {
    if (state == null) {
      throw FlutterError("Route provider hasn't been selected");
    }
    Map counterMap = await service.changeSentCount(state!.id, 'Nate');

    state!.setSentCounter(counterMap);
    notifyListeners();
  }

  setRating(double rating) async {
    if (state == null) {
      throw FlutterError("Route provider hasn't been selected");
    }

    Map ratingMap = await service.changeRating(state!.id, rating, 'Nate');
    state!.setRating(ratingMap);
    notifyListeners();
  }

  edit(WidgetRef ref, {String? grade, String? description, String? gym, required imageProvider, List<dynamic>? tagsChosen}) async {
    if (state == null) {
      throw FlutterError("Route provider hasn't been selected");
    }

    state!.edit(
      grade: grade,
      description: description,
      gym: gym,
      localPath: imageProvider.hasChanged() ? imageProvider.getImagePath() : null, //todo or just imageProvider.getLocalImage
      tags: tagsChosen,
    );
    notifyListeners();
    await ref
        .read(routeList.notifier)
        .editRoute(state!, newImage: imageProvider.hasChanged() ? imageProvider.getImage() : null); //todo or just imageProvider.getLocalImage
  }
}
