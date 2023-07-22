// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:send/database/db_util.dart';
import 'package:send/services/route_service.dart';

class RouteData {
  static const String ACTIVE_PATH = '/active/routes';

  static const String PHOTO = 'photo';
  static const String ICON = 'icon';
  static const String DATE_CREATED = 'datecreated';
  static const String GRADE = 'grade';
  static const String DESCRIPTION = 'description';
  static const String GYM = 'gym';
  static const String AUTHOR = 'author';
  static const String TAGS = 'tags';
  static const String SENT_COUNT = 'sent_counter';
  static const String SENT_COUNT_COUNTER = 'counter';
  static const String RATING = 'rating';
  static const String RATING_RATING = 'rating';
  static const String RATING_VOTES = 'votes';

  late Map<String, dynamic> _data;
  late String id;
  late Future<String?> _image;
  late Future<String?> _icon;
  String? localPath;

  RouteData(
      {required String grade,
      required String description,
      required String gym,
      required String this.localPath,
      required List<dynamic> tags,
      required String user}) {
    _data = {
      GRADE: grade,
      DESCRIPTION: description,
      GYM: gym,
      AUTHOR: user,
      TAGS: tags,
      DATE_CREATED: Timestamp.now(),
      RATING: {RouteData.RATING_VOTES: {}},
      SENT_COUNT: {RouteData.SENT_COUNT_COUNTER: {}}
    };

    id = "null";
  }

  RouteData.fromFirebase(DocumentSnapshot snapshot, RouteService service) {
    _data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    _image = service.getImageUrl(_data[RouteData.PHOTO]);
    _icon = service.getImageUrl(_data[RouteData.ICON]);
  }

  RouteData.withImage(DocumentSnapshot snapshot, String path) {
    _data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    _image = Future.value(path);
    _icon = _image;
  }

  String getRating() {
    final resp = optMap(_data, RATING)[RATING_RATING];
    if (resp == null) return 'Not yet rated';
    return '$resp';
  }

  double getUserRating(String user) {
    final values = optDeepMap(_data, [RATING, RATING_VOTES]);
    return optDouble(values, user);
  }

  int getSentCount() {
    return optDeepMap(_data, [SENT_COUNT, SENT_COUNT_COUNTER]).length;
  }

  bool hasUserSent(String user) {
    Map counter = optDeepMap(_data, [SENT_COUNT, SENT_COUNT_COUNTER]);
    return counter.containsKey(user);
  }

  String getDescription() {
    return optString(_data, DESCRIPTION);
  }

  String getGym() {
    return optString(_data, GYM);
  }

  String getGrade() {
    return optString(_data, GRADE);
  }

  String getPhotoPath() {
    return optString(_data, PHOTO);
  }

  String getIconPath() {
    return optString(_data, ICON);
  }

  String getAuthor() {
    return optString(_data, AUTHOR);
  }

  List<String> getTags() {
    return optList<String>(_data, TAGS);
  }

  Future<String?> getBestPathForPhoto() {
    if (localPath != null) {
      return Future.value(localPath);
    }
    return _image;
  }

  Future<String?> getBestPathForIcon() {
    if (localPath != null) {
      return Future.value(localPath);
    }
    return _icon;
  }

  /// only use for firebase write/update.
  Map<String, dynamic> getData() {
    return _data;
  }

  void setSentCounter(Map counterMap) {
    _data.putIfAbsent(SENT_COUNT, () => {});
    _data[SENT_COUNT][SENT_COUNT_COUNTER] = counterMap;
  }

  void setRating(Map newRating) {
    _data[RATING] = newRating;
  }

  void edit({String? grade, String? description, String? gym, String? localPath, List<dynamic>? tags}) {
    if (grade != null) _data[GRADE] = grade;
    if (description != null) _data[DESCRIPTION] = description;
    if (gym != null) _data[GYM] = gym;
    if (tags != null) _data[TAGS] = tags;

    if (localPath != null) this.localPath = localPath; //todo only use this in edit
  }

  void updateImages({required String ogRef, required String iconRef}) {
    _image = Future.value(ogRef);
    _data[PHOTO] = ogRef;

    _icon = Future.value(iconRef);
    _data[ICON] = iconRef;
  }

  void updateId(String id) {
    if (this.id != "null") throw FlutterError("This 'new' Route is not new. Try again");
    this.id = id;
  }

  @override
  bool operator ==(Object other) => other is RouteData && other.id == id;

  @override
  int get hashCode => id.hashCode;

  String? getLocalImage() {
    return localPath;
  }
}
