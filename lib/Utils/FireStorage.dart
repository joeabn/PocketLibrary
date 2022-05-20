import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  static final storage = FirebaseStorage.instance;

  static Future<UploadTask?> uploadFile(File file, String title) async {
    UploadTask uploadTask;

    Reference ref =
        FirebaseStorage.instance.ref().child('documents').child(title);

    uploadTask = ref.putFile(file);

    return Future.value(uploadTask);
  }
}
