import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:send/components/my_loader.dart';
import 'package:send/pages/route_page.dart';
import 'package:send/services/overview_service.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<List> list = OverviewService("V0").getById("id");


    return MyLoader(future: list, child: ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: ((context, index) {

                        var route = snapshot.data?[index];
                        return OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => RoutePage(route)));
                            },
                            child: Card(
                              child: ListTile(
                                  title: Text('here come item #$index'),
                                  subtitle: Text('test: ${route['ranking']}'),
                                  leading: Container(
                                    child: Text("Here comes a picture"),
                                  )),
                            ));
                      })))

    return FutureBuilder(
        future: list,
        builder: (context, snapshot) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: ((context, index) {

                        var route = snapshot.data?[index];
                        return OutlinedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => RoutePage(route)));
                            },
                            child: Card(
                              child: ListTile(
                                  title: Text('here come item #$index'),
                                  subtitle: Text('test: ${route['ranking']}'),
                                  leading: Container(
                                    child: Text("Here comes a picture"),
                                  )),
                            ));
                      }))
                  : Container(),
            ));
  }
}
