import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:send/database/route_data.dart';
import 'package:send/pages/add_route/add_route_photo_display.dart';
import 'package:send/provider/image_add_route_provider.dart';
import 'package:send/provider/login_provider.dart';
import 'package:send/services/route_service.dart';

class AddEditRoutePage extends StatefulWidget {
  final RouteData? routeData;
  const AddEditRoutePage({super.key, this.routeData});

  @override
  State<AddEditRoutePage> createState() => _AddEditRoutePageState();
}

class _AddEditRoutePageState extends State<AddEditRoutePage> {
  bool dataInitialized = false;
  TextEditingController gradingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController gymController = TextEditingController();

  initData(BuildContext providerContext) {
    final data = widget.routeData;
    if (data == null || dataInitialized) return;

    gradingController.text = data.getGrade();
    descriptionController.text = data.getDescription();
    gymController.text = data.getGym();

    Provider.of<ImageAddRouteProvider>(providerContext).setNetworkImage(data.image);
    dataInitialized = true;
  }

  _handleSave(BuildContext providerContext) async {
    try {
      var data = widget.routeData;
      var imageProvider = Provider.of<ImageAddRouteProvider>(providerContext, listen: false);
      if (data == null) {
        // new
        await RouteService().addRoute(
            grade: gradingController.text,
            description: descriptionController.text,
            gym: gymController.text,
            image: imageProvider.getImage(),
            user: Provider.of<LoginProvider>(providerContext, listen: false).getUser());
      } else {
        // edit
        data = await RouteService().editRoute(
            grade: gradingController.text, description: descriptionController.text, gym: gymController.text, imageProvider: imageProvider, route: data);
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(providerContext, data);
    } catch (e) {
      showModalBottomSheet(context: providerContext, builder: (_) => Text(e.toString()));
    }
  }

  bool _canSave(providerContext) {
    if (gradingController.text.isEmpty) return false;

    if (descriptionController.text.isEmpty) return false;

    if (gymController.text.isEmpty) return false;

    if (Provider.of<ImageAddRouteProvider>(providerContext).isEmpty()) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ImageAddRouteProvider(),
        builder: (providerContext, child) {
          initData(providerContext);

          return Scaffold(
              appBar: AppBar(
                title: const Text('New route'),
                leading: IconButton(onPressed: () => Navigator.pop(providerContext), icon: const Icon(Icons.cancel)),
                actions: [IconButton(onPressed: _canSave(providerContext) ? () => _handleSave(providerContext) : null, icon: const Icon(Icons.check))],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //Image
                      const AddRoutePhotoDisplay(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Grading
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                            child: const Text('Grading', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                              child: TextField(
                                controller: gradingController,
                                onChanged: (s) => setState(() {}),
                              )),

                          // Description
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                            child: const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                              child: TextField(
                                controller: descriptionController,
                                onChanged: (s) => setState(() {}),
                              )),

                          // Gym
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                            child: const Text('Gym', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                              child: TextField(
                                controller: gymController,
                                onChanged: (s) => setState(() {}),
                              )),

                          // Tags
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
                            child: const Text('Tags', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(border: Border.all(), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20))),
                              child: const TextField()),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
