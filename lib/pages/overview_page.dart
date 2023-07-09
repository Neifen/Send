import 'package:flutter/material.dart';
import 'package:send/components/my_loader.dart';
import 'package:send/database/route_data.dart';
import 'package:send/pages/add_route/add_route_page.dart';
import 'package:send/pages/route_page.dart';
import 'package:send/services/route_service.dart';
import 'package:camera_camera/camera_camera.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final overviewService = RouteService();
    final Future<List> list = RouteService().getAll();

    return Scaffold(
        appBar: AppBar(
          title: const Text('SEND'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_alt)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.explore)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.person)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRoutePage())),
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Column(
            children: [
              const SearchBar(leading: Icon(Icons.search)), //todo
              MyLoader(
                  future: list,
                  builder: (_, snapshot) => Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: snapshot.data?.length,
                            itemBuilder: ((_, index) {
                              RouteData routeData = RouteData(snapshot.data?[index], overviewService);

                              return OutlinedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => RoutePage(routeData)));
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  side: const BorderSide(width: 2),
                                ),
                                child: Card(
                                  child: ListTile(
                                      title: Text(routeData.getDescription()),
                                      subtitle: Text('test: ${routeData.getGrade()}'),
                                      leading: MyLoader(
                                        future: overviewService.getSmallImage(routeData.getPhoto()),
                                        builder: (context, snapshot) => Image.memory(snapshot.data),
                                      )),
                                ),
                              );
                            })),
                      )),
            ],
          ),
        ));
  }
}
