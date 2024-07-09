import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:summarizeai/screens/hh.dart';
import 'package:summarizeai/screens/pdfviewer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfUploadPage extends StatefulWidget {
  @override
  _PdfUploadPageState createState() => _PdfUploadPageState();
}

class _PdfUploadPageState extends State<PdfUploadPage> {
  File? _selectedFile;
  String? _extractedText;

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _extractedText = null; // Reset extracted text when a new file is picked
      });
    }
  }

  Future<void> _uploadPDF() async {
    if (_selectedFile == null) {
      // Handle case when no file is selected
      return;
    }

    var uri = Uri.parse(
        'http://192.168.218.195:8000/api/pdfsummary'); // Replace with your server endpoint

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'pdfFile',
        _selectedFile!.path,
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      // File uploaded successfully
      var responseBody = await response.stream.bytesToString();
      setState(() {
        _extractedText = json.decode(responseBody)['text'];
      });
    } else {
      // Error uploading file
      print('Failed to upload file');
      print(response.reasonPhrase);
    }
  }

  void _openPdfViewer() {
    if (_selectedFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => hh(file: _selectedFile!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  onPressed: _pickPDF,
                  child: Text('Select PDF', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, ),
                ),
              ),
              SizedBox(height: 20),
              if (_selectedFile != null)
                GestureDetector(
                  onTap: _openPdfViewer,
                  child: Container(
                    height: 500, // Increase the height of the PDF viewer
                    child: SfPdfViewer.file(
                      _selectedFile!,
                    ),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadPDF,
                child: Text('Upload PDF', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, )
              ),
              SizedBox(height: 20),
              if (_extractedText != null)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height:
                        500, // Increase the height of the extracted text container
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Background color
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(_extractedText!,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
