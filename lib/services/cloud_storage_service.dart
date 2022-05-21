import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CloudStorageService {
  static final storage = FirebaseStorage.instance;

  static Future<UploadTask?> uploadFile(File file, String title) async {
    UploadTask uploadTask;

    Reference ref =
        FirebaseStorage.instance.ref().child('documents').child(title);

    uploadTask = ref.putFile(file);

    return Future.value(uploadTask);
  }

  static Future<bool> deleteFile(String fileURL) async {
    Reference ref = FirebaseStorage.instance.refFromURL(fileURL);
    try {
      await ref.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
