// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:send/services/route_service.dart';

class RouteData {
  static const String PATH = '/routes/routes';

  static const String PHOTO = 'photo';
  static const String DATE_CREATED = 'datecreated';
  static const String GRADE = 'grade';
  static const String DESCRIPTION = 'description';
  static const String GYM = 'gym';
  static const String AUTHOR = 'author';
  static const String TAGS = 'tags';
  static const String SENT_COUNT = 'sent_count';
  static const String SENT_COUNT_COUNTER = 'counter';
  static const String RATING = 'rating';
  static const String RATING_RATING = 'rating';
  static const String RATING_VOTES = 'votes';

  late Map<String, dynamic> _data;
  late String id;
  late Future<String?> image;

  RouteData(DocumentSnapshot snapshot, RouteService service) {
    _data = snapshot.data() as Map<String, dynamic>;
    id = snapshot.id;
    image = service.getImageUrl(_data[RouteData.PHOTO]);
  }

  String getRating() {
    final resp = _data[RATING][RATING_RATING];
    if (resp == null) return 'Not yet rated';
    return '$resp';
  }

  double getUserRating(String user) {
    var values = _data[RATING][RATING_VOTES];
    return values?[user] ?? 0.0;
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

  String getGym() {
    return _data[GYM];
  }

  String getGrade() {
    return _data[GRADE];
  }

  String getPhotoPath() {
    return _data[PHOTO];
  }

  void setSentCounter(Map counterMap) {
    _data[SENT_COUNT][SENT_COUNT_COUNTER] = counterMap;
  }

  void setRating(Map newRating) {
    _data[RATING] = newRating;
  }

  void edit({required String grade, required String description, required String gym, required String path}) {
    _data[GRADE] = grade;
    _data[DESCRIPTION] = description;
    _data[GYM] = gym;
    image = Future.value(path);
  }
}
