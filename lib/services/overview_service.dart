import 'package:cloud_firestore/cloud_firestore.dart';

class OverviewService {
  FirebaseFirestore? db;
  String tenantId;

  OverviewService(this.tenantId) {
    db ??= FirebaseFirestore.instance;
  }

  Future<List> getById(String id) async {
    QuerySnapshot snapshot = await db!.collection(tenantId).get();
    return snapshot.docs;
  }
}
