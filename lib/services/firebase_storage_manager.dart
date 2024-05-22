import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../main.dart';

class FirebaseStorageManager {
  static const String profilePicturesPath = 'profile_pictures';

  static Future<String> _uploadFile(String path, String fileName) async {
    final Reference ref = storage.child(path).child(fileName);
    final UploadTask uploadTask = ref.putFile(File(fileName));
    final TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  static Future<String> uploadProfilePicture(File file) async {
    return await _uploadFile(profilePicturesPath, file.path);
  }
}
