import 'package:chat_smart_app/models/contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  static DbService instance = DbService();

  FirebaseFirestore _db;

  String _userCollection = "users";

  DbService() {
    _db = FirebaseFirestore.instance;
  }

  Future<void> createUserInDb(
      String _uid, String _name, String _email, String _imgUrl) async {
    try {
      return await _db.collection(_userCollection).doc(_uid).set({
        "name": _name,
        "email": _email,
        "image": _imgUrl,
        "lastSeen": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<Contact> getUserData(String _userID) {
    var _ref = _db.collection(_userCollection).doc(_userID);
    return _ref.get().asStream().map((_snapshot) {
      return Contact.fromFirestore(_snapshot);
    });
  }
}
