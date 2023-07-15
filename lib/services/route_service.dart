import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:send/database/route_data.dart';
import 'package:send/database/versioning.dart';
import 'package:send/provider/image_add_route_provider.dart';
import 'package:uuid/uuid.dart';

class RouteService {
  Future<List> getAll() async {
    final db = FirebaseFirestore.instance;

    QuerySnapshot snapshot = await db.collection(Versioning.DB_VERSION + RouteData.PATH).get();
    return snapshot.docs;
  }

  Future<String?> getImageUrl(String reference) {
    final storage = FirebaseStorage.instance;

    final Reference pathReference = storage.ref(reference);

    try {
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

    final sfDocRef = db.collection(Versioning.DB_VERSION + RouteData.PATH).doc(uid);
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

    final sfDocRef = db.collection(Versioning.DB_VERSION + RouteData.PATH).doc(uid);
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

  Future<dynamic> addRoute({required String grade, required String description, required String gym, required XFile image, required String user}) async {
    final path = "routes/${const Uuid().v1()}.jpg";
    final storage = FirebaseStorage.instance;
    try {
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );

      storage.ref(path).putData(await image.readAsBytes(), metadata);
    } on FirebaseException catch (e) {
      return Future.error(e);
    }

    Map<String, dynamic> route = {
      RouteData.GRADE: grade,
      RouteData.DESCRIPTION: description,
      RouteData.GYM: gym,
      RouteData.PHOTO: path,
      RouteData.AUTHOR: user,
      RouteData.DATE_CREATED: Timestamp.now(),
      RouteData.RATING: {RouteData.RATING_VOTES: {}},
      RouteData.SENT_COUNT: {RouteData.SENT_COUNT_COUNTER: {}}
    };

    final db = FirebaseFirestore.instance;
    DocumentReference ref = await db.collection(Versioning.DB_VERSION + RouteData.PATH).add(route);
    return ref;
  }

  Future<RouteData> editRoute(
      {required String grade, required String description, required String gym, required ImageAddRouteProvider imageProvider, required RouteData route}) async {
    final db = FirebaseFirestore.instance;
    final sfDocRef = db.collection(Versioning.DB_VERSION + RouteData.PATH).doc(route.id);

    await db.runTransaction((transaction) async {
      final snapshot = await transaction.get(sfDocRef);
      if (snapshot.data() == null || snapshot.data()!.isEmpty) throw FlutterError("Can't update field that doesn't exist on the Database");

      final localPath = imageProvider.getImagePath(); // can also be old path
      var path = localPath;

      if (!imageProvider.isOnline()) {
        final storage = FirebaseStorage.instance;
        //delete old
        final oldPhotoUrl = snapshot.data()![RouteData.PHOTO];
        storage.ref(oldPhotoUrl).delete();
        //add new
        try {
          final metadata = SettableMetadata(
            contentType: 'image/jpeg',
          );

          path = "routes/${const Uuid().v1()}.jpg";
          storage.ref(path).putData(await imageProvider.getImage().readAsBytes(), metadata);
        } on FirebaseException catch (e) {
          return Future.error(e);
        }
      }

      transaction.update(sfDocRef, {
        RouteData.GRADE: grade,
        RouteData.DESCRIPTION: description,
        RouteData.GYM: gym,
        RouteData.PHOTO: path,
      });

      route.edit(grade: grade, description: description, gym: gym, path: localPath);
    }).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"),
    );
    return route;
  }
}
