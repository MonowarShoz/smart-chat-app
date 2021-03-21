import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String name;
  final String email;
  final String image;
  final Timestamp lastSeen;

  Contact({this.id, this.name, this.email, this.image, this.lastSeen});

  factory Contact.fromFirestore(DocumentSnapshot snapshot) {
    var _data = snapshot.data();
    return Contact(
      id: snapshot.id,
      lastSeen: _data["lastSeen"],
      email: _data["email"],
      name: _data["name"],
      image: _data["image"],

    );
  }
}
