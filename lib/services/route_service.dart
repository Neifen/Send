import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:send/database/route_data.dart';
import 'package:send/database/versioning.dart';
import 'package:uuid/uuid.dart';

class RouteService {
  Future<List<DocumentSnapshot>> getAll() async {
    final db = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await db.collection(Versioning.DB_VERSION + RouteData.ACTIVE_PATH).get();
    return snapshot.docs;
  }

  Future<String?> getImageUrl(String reference) {
    final storage = FirebaseStorage.instance;

    try {
      final Reference pathReference = storage.ref(reference);
      return pathReference.getDownloadURL();
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<String?> getFullImage(String reference) {
    final storage = FirebaseStorage.instance;
    final Reference pathReference = storage.ref(reference);

    try {
      return pathReference.getDownloadURL();
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<Map> changeRating(String uid, double userRating, String user) async {
    if (userRating < 1 || userRating > 5) throw Exception('Rating can\'t be smaller than 1 or bigger than 5');
    final db = FirebaseFirestore.instance;

    final sfDocRef = db.collection(Versioning.DB_VERSION + RouteData.ACTIVE_PATH).doc(uid);
    Map newRating = {};
    await db.runTransaction((transaction) async {
      final snapshot = await transaction.get(sfDocRef);

      newRating = snapshot.get(RouteData.RATING);
      Map votes = newRating[RouteData.RATING_VOTES];
      if (votes.isNotEmpty) {
        final rating = newRating[RouteData.RATING_RATING];
        double newVote = 0;

        if (votes.containsKey(user)) {
          double oldVote = votes[user];
          newVote = ((rating * votes.length) + userRating - oldVote) / votes.length;
          newRating[RouteData.RATING_RATING] = newVote;
        } else {
          newVote = ((rating * votes.length) + userRating) / (votes.length + 1);
          newRating[RouteData.RATING_RATING] = newVote;
        }
      } else {
        newRating[RouteData.RATING_RATING] = userRating;
      }
      votes[user] = userRating;

      transaction.update(sfDocRef, {RouteData.RATING: newRating});
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
    return newRating;
  }

  Future<Map> changeSentCount(String uid, String user) async {
    final db = FirebaseFirestore.instance;

    final sfDocRef = db.collection(Versioning.DB_VERSION + RouteData.ACTIVE_PATH).doc(uid);
    Map counter = {};
    await db.runTransaction((transaction) async {
      final snapshot = await transaction.get(sfDocRef);

      Map newSentCount = snapshot.get(RouteData.SENT_COUNT);
      counter = newSentCount[RouteData.SENT_COUNT_COUNTER];
      if (counter.remove(user) == null) counter[user] = 1;

      transaction.update(sfDocRef, {RouteData.SENT_COUNT: newSentCount});
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
    return counter;
  }

  Future<Uint8List> compress(Uint8List list, int quality) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: quality,
      rotate: 135,
    );
    return result;
  }

  upload(Future<Uint8List> imageBytes, {required String storeRef, int quality = 80}) async {
    final storage = FirebaseStorage.instance;
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );

    Uint8List data;
    data = await compress(await imageBytes, quality);

    storage.ref(storeRef).putData(data, metadata);
  }

  Future<RouteData> addRoute(RouteData route, {required XFile image}) async {
    String uuid = const Uuid().v1();
    final ogRef = "routes/$uuid.jpg";
    final iconRef = "icons/$uuid.jpg";
    try {
      upload(image.readAsBytes(), storeRef: ogRef);
      upload(image.readAsBytes(), storeRef: iconRef, quality: 20);
    } on FirebaseException catch (e) {
      return Future.error(e);
    }

    route.updateImages(ogRef: ogRef, iconRef: iconRef);

    final db = FirebaseFirestore.instance;
    var newRoute = await db.collection(Versioning.DB_VERSION + RouteData.ACTIVE_PATH).add(route.getData());

    route.updateId(newRoute.id);

    return route;
  }

  Future<RouteData> updateRoute(RouteData route, {XFile? newImage}) async {
    final db = FirebaseFirestore.instance;
    final sfDocRef = db.collection(Versioning.DB_VERSION + RouteData.ACTIVE_PATH).doc(route.id);

    await db.runTransaction((transaction) async {
      final oldRoute = (await transaction.get(sfDocRef)).data();
      if (oldRoute == null || oldRoute.isEmpty) throw FlutterError("Can't update field that doesn't exist on the Database");

      if (newImage != null) {
        final storage = FirebaseStorage.instance;
        //delete old
        final oldPhotoUrl = oldRoute[RouteData.PHOTO];
        final oldIconUrl = oldRoute[RouteData.ICON];

        //add new
        try {
          final uuid = const Uuid().v1();
          final ogStoreRef = "routes/$uuid.jpg";
          final iconStoreRef = "icons/$uuid.jpg";

          await upload(newImage.readAsBytes(), storeRef: ogStoreRef);
          await upload(newImage.readAsBytes(), storeRef: iconStoreRef, quality: 20);

          storage.ref(oldPhotoUrl).delete().catchError((err) => print(err));
          storage.ref(oldIconUrl).delete().catchError((err) => print(err));

          route.updateImages(ogRef: ogStoreRef, iconRef: iconStoreRef);
        } on FirebaseException catch (e) {
          return Future.error(e);
        }
      }

      transaction.update(sfDocRef, route.getData());
      print("route successfully updated! (right after transaction.update)");
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );

    return route;
  }
}
