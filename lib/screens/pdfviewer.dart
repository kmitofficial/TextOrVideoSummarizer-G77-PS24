import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class PdfViewer extends StatefulWidget {
  final File file;

  const PdfViewer({Key? key, required this.file}) : super(key: key);

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late File _file;

  @override
  void initState() {
    super.initState();
    _file = widget.file;
    print('myfile');
    print(_file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.file(
        _file,
      ),
    );
  }
}
