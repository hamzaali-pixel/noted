import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // For MediaType
import 'generated_notes_screen.dart';

class PlaybackScreen extends StatefulWidget {
  final String filePath;

  PlaybackScreen({required this.filePath});

  @override
  _PlaybackScreenState createState() => _PlaybackScreenState();
}

class _PlaybackScreenState extends State<PlaybackScreen> {
  late AudioPlayer _audioPlayer;
  PlayerState _playerState = PlayerState.stopped;
  Duration _duration = Duration();
  Duration _position = Duration();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setAudio();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });
    _audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() => _playerState = s);
    });
  }

  void _setAudio() async {
    await _audioPlayer.setSource(DeviceFileSource(widget.filePath));
  }

  void _playPause() {
    if (_playerState == PlayerState.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(DeviceFileSource(widget.filePath));
    }
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'aac':
        return 'audio/aac';
      case 'm4a':
        return 'audio/mp4';
      case 'flac':
        return 'audio/flac';
      default:
        return 'application/octet-stream';
    }
  }

  void _generateNotes() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      File audioFile = File(widget.filePath);
      String extension = widget.filePath.split('.').last;
      String mimeType = _getMimeType(extension);

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'files',
        audioFile.path,
        contentType: MediaType.parse(mimeType),
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://965e-74-63-216-34.ngrok-free.app/transcribe'),
      );
      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        String notes = jsonResponse['notes'];

        setState(() {
          _isGenerating = false;
        });

        Navigator.pushNamed(
          context,
          '/generatedNotes',
          arguments: notes,
        );
      } else {
        String errorResponse = await response.stream.bytesToString();
        setState(() {
          _isGenerating = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate notes: $errorResponse')),
        );
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        // Navigate directly to the home screen using pushReplacementNamed
        Navigator.pushReplacementNamed(context, '/');
      },
      child:  Scaffold(
      body: Stack(
        children: [
          // Banner Container at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color.fromARGB(255, 39, 36, 42), // Banner background color
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/icon.png', // Your image path
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
                  ),
                  const SizedBox(width: 10), // Spacing between image and text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                    children: [
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Not',
                              style: TextStyle(
                                color: Color.fromARGB(255, 229, 196, 255), // Text color
                                fontSize: 32, // Font size for "Not"
                                fontFamily: 'Horizon',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Ed.',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 147, 59, 198), // Text color for "Ed."
                                fontSize: 35, // Font size for "Ed."
                                fontFamily: 'Horizon',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Your Note Taking Assistant',
                        style: TextStyle(
                          color: Color.fromARGB(255, 235, 227, 227), // Text color
                          fontSize: 18, // Adjusted font size for readability
                          fontFamily: 'Horizon',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Centered Playback Controls
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20),
                  IconButton(
                    iconSize: 64,
                    icon: Icon(
                      _playerState == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed: _playPause,
                  ),
                  Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value:
                        _position.inSeconds.clamp(0, _duration.inSeconds).toDouble(),
                    onChanged: (double value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                  ),
                  Text(
                      '${_formatDuration(_position)} / ${_formatDuration(_duration)}'),
                  SizedBox(height: 20),
                  _isGenerating
                      ? Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Generating Notes, please wait...'),
                          ],
                        )
                      : ElevatedButton(
                          onPressed: _generateNotes,
                          child: Text('Generate Notes'),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}
