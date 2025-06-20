import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

class ShareController extends GetxController {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<UploadTask> _uploadTask(Reference reference, XFile xImage) async {
    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': xImage.path});
    UploadTask uploadTask;
    if (kIsWeb) {
      uploadTask = reference.putData(await xImage.readAsBytes(), metadata);
    } else {
      uploadTask = reference.putFile(File(xImage.path), metadata);
    }
    return Future.value(uploadTask);
  }
}
