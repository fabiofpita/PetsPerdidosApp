import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class Storage {
  Future<String> gravarArquivo(File file);
}

class StorageData extends Storage {
  final FirebaseStorage instance = FirebaseStorage.instance;

  @override
  Future<String> gravarArquivo(File file) async {
    String photoUrl = "";
    if (file != null) {
      final StorageUploadTask uploadTask = instance.ref().putFile(file);

      final StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      photoUrl = await taskSnapshot.ref.getDownloadURL();
    }

    return photoUrl;
  }
}
