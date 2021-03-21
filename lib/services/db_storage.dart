import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class DbStorageService {
  static DbStorageService instance = DbStorageService();

  FirebaseStorage storage;
  Reference reference;

  String profileImage = "profile_image";
  String uri;
  var images = "images";

  DbStorageService() {
    storage = FirebaseStorage.instance;
    reference = storage.ref();
  }

  Future<TaskSnapshot> uploadUserImage(String uid, File image) async {
  
      return reference.child(profileImage).child(uid).putFile(image);
    
    
    
    
  }
}
