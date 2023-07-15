import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageAddRouteProvider extends ChangeNotifier {
  XFile? _image;
  String? _networkImage;

  deleteImage() {
    _networkImage = _networkImage = null;
    notifyListeners();
  }

  bool isEmpty() {
    return _image == null && _networkImage == null;
  }

  bool isOnline() {
    return _image == null && _networkImage != null;
  }

  String getImagePath() {
    if (isEmpty()) throw FlutterError('Image has not been set yet');

    return _image?.path ?? _networkImage!;
  }

  XFile getImage() {
    if (_image == null) throw FlutterError('Image has not been set yet');

    return _image!;
  }

  void setImage(Future<XFile?> xFileF) async {
    final XFile? photo = await xFileF;
    _image = photo;
    _networkImage = null;

    notifyListeners();
  }

  void setNetworkImage(Future<String?> path) async {
    final String? photo = await path;
    _networkImage = photo;

    notifyListeners();
  }
}
