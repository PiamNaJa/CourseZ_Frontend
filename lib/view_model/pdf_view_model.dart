import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class PDFViewModel {
  Future<Uint8List> getPdfBytes(String url) async {
    final ref = FirebaseStorage.instance.ref().child(url);
    final file = await ref.getData();
    return file!;
  }
}
