import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:send/components/my_loader.dart';
import 'package:send/database/route_data.dart';
import 'package:send/pages/add_route/add_edit_route_page.dart';
import 'package:send/pages/route_page.dart';
import 'package:send/provider/route_list_provider.dart';
import 'package:send/provider/selected_router_provider.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditRoutePage())),
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Column(
            children: [
              const SearchBar(leading: Icon(Icons.search)), //todo with filter in riverpod
              MyLoader(
                  future: ref.watch(routeList.future),
                  builder: (_, snapshot) => Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: snapshot.data?.length,
                            itemBuilder: ((_, index) {
                              RouteData routeData = snapshot.data?[index];

                              return OutlinedButton(
                                onPressed: () {
                                  ref.read(selectedRoute.notifier).selectRoute(routeData);
                                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutePage()));
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
                                        future: routeData.getBestPathForIcon(),
                                        builder: (context, snapshot) => Image.network(snapshot.data),
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
