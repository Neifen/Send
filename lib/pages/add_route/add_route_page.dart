import 'dart:developer';
import 'dart:io';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AddRoutePage extends StatefulWidget {
  const AddRoutePage({super.key});

  @override
  State<AddRoutePage> createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  Future? photoFuture;
  bool first = true;

  @override
  Widget build(BuildContext context) {
    if (first) {
      first = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        photoFuture = await _getPhotoFromCamera(context);
        if (mounted) setState(() {});
      });
    }

    return FutureBuilder(
        future: photoFuture,
        initialData: const SizedBox.shrink(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              break;

            case ConnectionState.none:
              log('No connection to camera');
              Navigator.pop(context);
              break;

            case ConnectionState.done:
              if (snapshot.hasError) {
                log(snapshot.error.toString());
                Navigator.pop(context);
                break;
              }

              if (!snapshot.hasData) {
                Navigator.pop(context);
              }
              File file = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Adding a new route'),
                ),
                body: Container(
                  child: kIsWeb
                      ? Image.network(file.path)
                      : Image.file(
                          file,
                          fit: BoxFit.cover,
                        ),
                ),
              );
          }
          return const SizedBox.shrink();
        });
  }

  Future<dynamic> _getPhotoFromCamera(BuildContext context) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) {
      return CameraCamera(
        onFile: (file) {
          Navigator.pop(context, file);
        },
      );
    }));
  }
}
