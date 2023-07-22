import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:send/provider/image_add_route_provider.dart';

class AddRoutePhotoDisplay extends StatefulWidget {
  const AddRoutePhotoDisplay({super.key});

  @override
  State<AddRoutePhotoDisplay> createState() => _AddRoutePhotoDisplayState();
}

class _AddRoutePhotoDisplayState extends State<AddRoutePhotoDisplay> {
  @override
  Widget build(BuildContext context) {
    ImageAddRouteProvider imageProvider = context.watch<ImageAddRouteProvider>();
    if (imageProvider.isEmpty()) {
      return Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: (() => _handleNewPhoto(ImagePicker().pickImage(source: ImageSource.camera))),
                  icon: const Icon(Icons.camera)),
              IconButton.outlined(
                  padding: const EdgeInsets.all(8.0),
                  onPressed: (() => _handleNewPhoto(ImagePicker().pickImage(source: ImageSource.gallery))),
                  icon: const Icon(Icons.image))
            ],
          ));
    }

    return Container(
        margin: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(border: Border.all(width: 2), borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            child: Stack(
              children: [
                InteractiveViewer(
                  maxScale: 5,
                  child: kIsWeb || imageProvider.isOnline()
                      ? Image.network(
                          imageProvider.getImagePath(),
                          height: 400,
                        )
                      : Image.file(
                          File(imageProvider.getImagePath()),
                          height: 400,
                          fit: BoxFit.cover,
                        ),
                ),
                IconButton.filledTonal(onPressed: _handleDeletePhoto, icon: const Icon(Icons.delete))
              ],
            )));
  }

  _handleDeletePhoto() {
    context.read<ImageAddRouteProvider>().deleteImage();
  }

  _handleNewPhoto(Future<XFile?> xFileF) async {
    context.read<ImageAddRouteProvider>().updateLocalImage(xFileF);
  }
}
