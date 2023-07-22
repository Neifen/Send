import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:send/database/route_data.dart';
import 'package:send/services/route_service.dart';

final routeList = AsyncNotifierProvider<RouteListProvider, List<RouteData>>(RouteListProvider.new);

class RouteListProvider extends AsyncNotifier<List<RouteData>> {
  @override
  FutureOr<List<RouteData>> build() async {
    return _getList();
  }

  reloadAll() async {
    state = const AsyncLoading();
    state = AsyncValue.data(await _getList());
  }

  FutureOr<List<RouteData>> _getList() async {
    var routeService = RouteService();
    var list = await RouteService().getAll();
    return list.map((e) => RouteData.fromFirebase(e, routeService)).toList();
  }

  addRoute(RouteData route, {required XFile image}) async {
    update((p0) async {
      var newRoute = await RouteService().addRoute(route, image: image);
      return [...p0, newRoute];
    });
  }

  Future<RouteData> editRoute(RouteData data, {XFile? newImage}) async {
    // edit
    data = await RouteService().updateRoute(data, newImage: newImage);

    //todo add a loadingProvider family maybe
    await update((p0) {
      p0[p0.indexOf(data)] = data;
      return p0;
    });

    return data;
  }
}
