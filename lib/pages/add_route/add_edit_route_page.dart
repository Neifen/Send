import 'package:flutter/material.dart';
import 'package:choose_input_chips/choose_input_chips.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as change_this;
import 'package:send/database/route_data.dart';
import 'package:send/pages/add_route/add_route_photo_display.dart';
import 'package:send/provider/image_add_route_provider.dart';
import 'package:send/provider/login_provider.dart';
import 'package:send/provider/route_list_provider.dart';
import 'package:send/provider/selected_router_provider.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class AddEditRoutePage extends ConsumerStatefulWidget {
  const AddEditRoutePage({super.key});
  @override
  ConsumerState<AddEditRoutePage> createState() => _AddEditRoutePageState();
}

class _AddEditRoutePageState extends ConsumerState<AddEditRoutePage> {
  static const availableTags = [
    'Overhang',
    'Arrete',
    'Sitstart',
    'Topout',
    'Multiple Starts',
    'Sloper',
    'Short',
    'Long',
    'Endurance',
    'Technical move',
    'Balance'
  ];

  bool dataInitialized = false;
  TextEditingController gradingController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController gymController = TextEditingController();
  List<String> tagsChosen = [];

  initData(BuildContext providerContext) {
    final data = ref.watch(selectedRoute).state;
    if (data == null || dataInitialized) return;

    gradingController.text = data.getGrade();
    descriptionController.text = data.getDescription();
    gymController.text = data.getGym();
    tagsChosen = data.getTags();

    change_this.Provider.of<ImageAddRouteProvider>(providerContext).initImage(data.getBestPathForPhoto());
    dataInitialized = true;
  }

  _handleSave(BuildContext providerContext) async {
    try {
      ref.read(loadingProvider.notifier).state = true;

      final data = ref.read(selectedRoute.notifier);
      var imageProvider = change_this.Provider.of<ImageAddRouteProvider>(providerContext, listen: false);
      if (data.routePicked()) {
        data.edit(ref,
            grade: gradingController.text,
            description: descriptionController.text,
            gym: gymController.text,
            imageProvider: imageProvider,
            tagsChosen: tagsChosen);
      } else {
        final newRoute = RouteData(
            grade: gradingController.text,
            description: descriptionController.text,
            gym: gymController.text,
            localPath: imageProvider.getImagePath(),
            user: ref.read(loginProvider),
            tags: tagsChosen);

        ref.read(routeList.notifier).addRoute(newRoute, image: imageProvider.getImage());
      }

      ref.read(loadingProvider.notifier).state = false;
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

    if (change_this.Provider.of<ImageAddRouteProvider>(providerContext).isEmpty()) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return change_this.ChangeNotifierProvider(
        create: (_) => ImageAddRouteProvider(),
        builder: (providerContext, child) {
          initData(providerContext);

          return Stack(
            children: [
              Scaffold(
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
                                  child: ChipsInput<String>(
                                      initialValue: tagsChosen,
                                      chipBuilder: (ctx, state, profile) => InputChip(onDeleted: () => state.deleteChip(profile), label: Text(profile)),
                                      suggestionBuilder: (ctx, state, profile) => ListTile(
                                            onTap: () => state.selectSuggestion(profile),
                                            title: Text(profile),
                                          ),
                                      findSuggestions: (query) =>
                                          availableTags.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList(),
                                      onChanged: (data) => tagsChosen = data)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
              if (ref.watch(loadingProvider))
                Container(
                    color: Colors.grey.withOpacity(0.4),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: const Center(child: CircularProgressIndicator()))
            ],
          );
        });
  }
}
