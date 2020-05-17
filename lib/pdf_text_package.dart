import 'dart:async';

import 'package:flutter/services.dart';

class PdfTextPackage {
  static const MethodChannel _channel = const MethodChannel('pdf_text_package');

  static Future<String> getPDFtext(String path) async {
    // Mapping the path to <key, value>
    final String pdfText = await _channel
        .invokeMethod('getPDFtext', <String, dynamic>{'path': path});
    return pdfText;
  }
}
