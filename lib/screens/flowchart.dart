import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MindMapApp extends StatelessWidget {
  const MindMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MindMapScreen()
    );
  }
}

class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key});

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen>
  with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  String _mindMapCode = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchMindMapCode();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchMindMapCode() async {
    final response = await http.post(
      Uri.parse('http://192.168.205.195:8000/generate-mind-map'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'text': """
  Database Management Systems (DBMS) are software systems designed to manage and facilitate the creation, manipulation, and administration of databases. A DBMS provides a systematic way to create, retrieve, update, and manage data, ensuring data integrity, security, and consistency. It allows multiple users and applications to interact with the data concurrently without compromising its integrity. Key concepts within DBMS include data models (such as relational, hierarchical, and network models), Structured Query Language (SQL) for querying and managing data, transaction management to ensure data reliability through ACID properties (Atomicity, Consistency, Isolation, Durability), and indexing for efficient data retrieval. By abstracting the complexities of data storage and handling, DBMSs play a crucial role in a wide range of applications, from small personal projects to large-scale enterprise systems.        """,
        'api_key': 'your_api_key_here',
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _mindMapCode = jsonDecode(response.body)['mind_map_code'];
        _loadMindMap();
      });
    } else {
      throw Exception('Failed to load mind map code');
    }
  }

  void _loadMindMap() {
    if (_mindMapCode.isNotEmpty) {
      final String htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
          <script type="module">
            import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
            mermaid.initialize({startOnLoad:true});
          </script>
        </head>
        <body>
          <div class="mermaid">
            $_mindMapCode
          </div>
        </body>
        </html>
      """;

      _writeHtmlToFile(htmlContent).then((filePath) {
        _controller.loadFile(filePath);
      });
    }
  }

  Future<String> _writeHtmlToFile(String htmlContent) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/mind_map.html';
    final file = File(filePath);
    await file.writeAsString(htmlContent);
    return filePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Map Viewer',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: WebView(
          initialUrl: 'about:blank',
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
