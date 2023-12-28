import 'package:firebase_storage/firebase_storage.dart';
import 'package:friendscape/models/requestResult.dart';
import 'package:flutter/material.dart';

class CloudStorageService {

  FirebaseStorage instance = FirebaseStorage.instance;

  Future<RequestResult> getImage(String path) async {
    try {
      MemoryImage image = MemoryImage((await instance.ref(path).getData())!);
      return RequestResult(false, image);
    } catch(e) {
      return RequestResult(true, e.toString());
    }
  }

}