//create a stateful widget and post the data to the server and fetch the summary of the video

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:summarizeai/utils/Hexcolor.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;

class YtSum extends StatefulWidget {
  const YtSum({Key? key}) : super(key: key);

  @override
  _YtSumState createState() => _YtSumState();
}

class _YtSumState extends State<YtSum> {
  late YoutubePlayerController _controller;
  String finalsum = 'Your summary will appear here';
  final _textController = TextEditingController();
  Future<String> getVideoSummary(String videoLink) async {
    final response = await http.post(
      Uri.parse('http://192.168.0.101:8000/api/get_yt_summary'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'link': videoLink}),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      // print(jsonResponse['summary']);
      return jsonResponse['summary'];
    } else {
      throw Exception('Failed to load summary');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 15.0,
                bottom: 15.0,
              ),
              child: SizedBox(
                height: 80,
                width: screenSize.width - 50,
                child: SingleChildScrollView(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Paste the YouTube video link here',
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onSubmitted: (value) async {
                      var videoId = YoutubePlayer.convertUrlToId(value);
                      if (videoId != null) {
                        _controller.load(videoId);
                        String summary = await getVideoSummary(value);
                        setState(() {
                          finalsum = summary;
                          print(finalsum);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: screenSize.width - 20,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: HexColor('#6D90DC'),
                    ),
                    child: YoutubePlayer(controller: _controller)),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 35,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  child: Text(
                    finalsum,
                    style: TextStyle(color: Colors.white,fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
