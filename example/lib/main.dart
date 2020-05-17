import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:pdf_text_package/pdf_text_package.dart';

import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _pdfText = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(children: [
          FlatButton(
            color: Colors.blueGrey,
            onPressed: () {
              FilePicker.getFile(
                allowedExtensions: ["pdf"],
                type: FileType.custom,
              ).then((File file) async {
                if (file.path.isNotEmpty) {
                  // Call the function to parse text from pdf
                  getPDFtext(file.path).then((pdfText) {
                    final text = pdfText.replaceAll("\n", " ");
                    setState(() {
                      _pdfText = text;
                    });
                  });
                }
              });
            },
            child: Text("Get pdf text"),
          ),
          Expanded(
            child: Text("Result: $_pdfText"),
          ),
        ]),
      ),
    );
  }

  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await PdfTextPackage.getPDFtext(path);
    } on PlatformException {
      text = 'Failed to get PDF text.';
    }
    return text;
  }
}
