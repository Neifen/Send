import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:send/database/route_data.dart';
import 'package:send/database/versioning.dart';

class RouteService {
  late FirebaseFirestore db;
  late Reference storage;

  RouteService() {
    db = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance.ref();
  }

  Future<List> getAll() async {
    QuerySnapshot snapshot = await db.collection(Versioning.DB_VERSION + RouteData.PATH).get();
    return snapshot.docs;
  }

  Future<Uint8List?> getSmallImage(String reference) {
    final Reference pathReference = storage.child(reference);

    const oneMegabyte = 1024 * 1024;

    try {
      return pathReference.getData(oneMegabyte);
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<Uint8List?> getFullImage(String reference) {
    final Reference pathReference = storage.child(reference);

    try {
      return pathReference.getData();
    } on FirebaseException catch (e) {
      return Future.error(e);
    }
  }

  Future<Map> changeRating(String uid, double userRating, String user) async {
    if (userRating < 1 || userRating > 5) throw Exception('Rating can\'t be smaller than 1 or bigger than 5');

    final sfDocRef = db.collection(Versioning.DB_VERSION + RouteData.PATH).doc(uid);
    Map newRating = {};
    await db.runTransaction((transaction) async {
      final snapshot = await transaction.get(sfDocRef);

      newRating = snapshot.get(RouteData.RATING);
      double rating = newRating[RouteData.RATING_RATING];
      Map votes = newRating[RouteData.RATING_VOTES];
      double newVote = 0;

      if (votes.containsKey(user)) {
        double oldVote = votes[user];
        newVote = ((rating * votes.length) + userRating - oldVote) / votes.length;
        newRating[RouteData.RATING_RATING] = newVote;
      } else {
        newVote = ((rating * votes.length) + userRating) / (votes.length + 1);
        newRating[RouteData.RATING_RATING] = newVote;
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
}
