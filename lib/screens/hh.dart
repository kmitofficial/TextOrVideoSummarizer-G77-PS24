import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class hh extends StatefulWidget {
  final File file;

  const hh({Key? key, required this.file}) : super(key: key);

  @override
  _hhState createState() => _hhState();
}

class _hhState extends State<hh> {
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
      appBar: AppBar(
        title: const Text('hh'),
      ),
      body: SfPdfViewer.file(
        _file,
      ),
    );
  }
}
