import 'dart:js_interop';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    var future = Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CameraCamera(
                  onFile: (file) {
                    Navigator.pop(context, !file.isUndefinedOrNull);
                  },
                )));

    return const Placeholder();
  }
}
