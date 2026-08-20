import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String?> getCompanyId(String uid) async {
    final snap = await db.collection('users').doc(uid).get();
    return snap.data()?['companyId'] as String?;
  }

  CollectionReference<Map<String, dynamic>> collection(
    String name,
  ) => db.collection(name);

  Future<String> add(
    String collection,
    Map<String, dynamic> data,
  ) async {
    final ref = db.collection(collection).doc();
    await ref.set({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  Future<void> update(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    await db.collection(collection).doc(id).update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String collection, String id) {
    return db.collection(collection).doc(id).delete();
  }
}
