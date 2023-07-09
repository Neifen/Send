// ignore_for_file: constant_identifier_names

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:send/services/route_service.dart';

class RouteData {
  static const String PATH = '/routes/routes';

  static const String PHOTO = 'photo';
  static const String DATE_CREATED = 'datecreated';
  static const String GRADE = 'grade';
  static const String DESCRIPTION = 'description';
  static const String TAGS = 'tags';
  static const String SENT_COUNT = 'sent_count';
  static const String SENT_COUNT_COUNTER = 'counter';
  static const String RATING = 'rating';
  static const String RATING_RATING = 'rating';
  static const String RATING_VOTES = 'votes';

  late Map<String, dynamic> _data;
  late String id;
  late Future<Uint8List?> image;

  RouteData(DocumentSnapshot snapshot, RouteService service) {
    _data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    image = service.getSmallImage(_data[RouteData.PHOTO]);
  }

  double getRating() {
    return _data[RATING][RATING_RATING];
  }

  double getUserRating(String user) {
    var values = _data[RATING][RATING_VOTES];
    return values[user] ?? 0.0;
  }

  int getSentCount() {
    return _data[SENT_COUNT][SENT_COUNT_COUNTER].length;
  }

  bool hasUserSent(String user) {
    Map counter = _data[SENT_COUNT][SENT_COUNT_COUNTER];
    return counter.containsKey(user);
  }

  String getDescription() {
    return _data[DESCRIPTION];
  }

  String getGrade() {
    return _data[GRADE];
  }

  String getPhoto() {
    return _data[PHOTO];
  }

  void setSentCounter(Map counterMap) {
    _data[SENT_COUNT][SENT_COUNT_COUNTER] = counterMap;
  }

  void setRating(Map newRating) {
    _data[RATING] = newRating;
  }
}
