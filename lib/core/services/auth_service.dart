import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    required String companyName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    final companyRef = _db.collection('companies').doc();
    await companyRef.set({
      'name': companyName,
      'ownerId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'companyId': companyRef.id,
      'role': 'admin',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return credential;
  }

  Future<void> signOut() => _auth.signOut();

  Future<Map<String, dynamic>?> currentUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final snap = await _db.collection('users').doc(uid).get();
    return snap.data();
  }
}
