import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String firstName,
    required String lastName,
    required String email,
    String role = 'user',
  }) async {
    await _db.collection('users').doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  Future<DocumentSnapshot> getUserProfile(String uid) {
    return _db.collection('users').doc(uid).get();
  }

  Stream<QuerySnapshot> getMessages(String boardName) {
    return _db
        .collection('boards')
        .doc(boardName)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage({
    required String boardName,
    required String uid,
    required String username,
    required String message,
  }) async {
    await _db.collection('boards').doc(boardName).collection('messages').add({
      'message': message,
      'userId': uid,
      'username': username,
      'timestamp': Timestamp.now(),
    });
  }
}