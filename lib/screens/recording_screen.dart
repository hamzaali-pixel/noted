import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isPaused = false;
  Timer? _timer;
  int _recordDuration = 0;
  String _filePath = '';

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is required')),
      );
      Navigator.pop(context);
      return;
    }

    await _audioRecorder!.openRecorder();
    setState(() {
      _isRecorderInitialized = true;
    });
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) return;

    Directory tempDir = await getTemporaryDirectory();
    String path =
        '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _audioRecorder!.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );

    setState(() {
      _isRecording = true;
      _isPaused = false;
      _filePath = path;
      _startTimer();
    });
  }

  Future<void> _pauseRecording() async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.pauseRecorder();
    setState(() {
      _isPaused = true;
      _stopTimer();
    });
  }

  Future<void> _resumeRecording() async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.resumeRecorder();
    setState(() {
      _isPaused = false;
      _startTimer();
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized) return;

    await _audioRecorder!.stopRecorder();
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _stopTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

 @override
void dispose() {
  _timer?.cancel(); // Cancel any running timer
  _audioRecorder?.closeRecorder(); // Ensure recorder is properly closed
  _audioRecorder = null;
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // Banner Container at the top
          
          // Centered Recording Controls
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (_isRecording) {
                      if (_isPaused) {
                        _resumeRecording();
                      } else {
                        _pauseRecording();
                      }
                    } else {
                      _startRecording();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(40),
                    backgroundColor: _isRecording && !_isPaused
                        ? const Color.fromARGB(255, 255, 17, 0)
                        : const Color.fromARGB(255, 147, 59, 198),
                  ),
                  child: Icon(
                    _isRecording && !_isPaused ? Icons.pause : Icons.mic,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _formatTime(_recordDuration),
                  style: TextStyle(fontSize: 48),
                ),
                if (_isRecording)
                  ElevatedButton(
                    onPressed: () async {
                      await _stopRecording();
                      Navigator.pushNamed(
                        context,
                        '/playback',
                        arguments: _filePath,
                      );
                    },
                    child: Text('Go to Playback'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
