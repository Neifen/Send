import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageAddRouteProvider extends ChangeNotifier {
  XFile? _localImage;
  String? _networkImage;
  bool _imageUpdated = false;

  deleteImage() {
    _networkImage = _networkImage = null;
    notifyListeners();
  }

  bool isEmpty() {
    return _localImage == null && _networkImage == null;
  }

  bool isOnline() {
    return _localImage == null && _networkImage != null;
  }

  bool hasChanged() {
    return _imageUpdated;
  }

  String getImagePath() {
    if (isEmpty()) throw FlutterError('Image has not been set yet');

    return _localImage?.path ?? _networkImage!;
  }

  XFile getImage() {
    if (_localImage == null) throw FlutterError('Image has not been set yet');

    return _localImage!;
  }

  void updateLocalImage(Future<XFile?> xFileF) async {
    final XFile? photo = await xFileF;
    _localImage = photo;
    _networkImage = null;
    _imageUpdated = true;

    notifyListeners();
  }

  void initImage(Future<String?> path) async {
    final String? photo = await path;
    _networkImage = photo;

    notifyListeners();
  }
}
