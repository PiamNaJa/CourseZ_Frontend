import 'dart:typed_data';

import 'package:http/http.dart' as http;

class PDFViewModel {
  Future<Uint8List> getPdfBytes(String url) async {
    final Uint8List bytes = await http.readBytes(Uri.parse(url));
    return bytes;
  }
}
