import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audio_notes_app/widgets/UI%20elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter_sound/flutter_sound.dart' as fs;

class RecorderScreen extends StatefulWidget {
  final String? existingFilePath;

  // Constructor accepts an optional existingFilePath for when uploaded from library
  const RecorderScreen({Key? key, this.existingFilePath}) : super(key: key);

  @override
  _RecorderScreenState createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> with SingleTickerProviderStateMixin {
  // Recording variables
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  bool _isPaused = false;
  Timer? _timer;
  int _recordDuration = 0;
  String _filePath = '';

  // Playback variables
  late AudioPlayer _audioPlayer;
  ap.PlayerState _playerState = ap.PlayerState.stopped;
  Duration _duration = Duration();
  Duration _position = Duration();
  bool _isPlaybackMode = false;
  bool _isGenerating = false;

  // UI Animation
  late AnimationController _animationController;
  
  // Note generation options
  String _selectedMode = 'Detailed Notes';
  final List<String> _modes = ['Detailed Notes', 'Summarization', 'Transcript'];

  @override
  void initState() {
    super.initState();
    
    // Initialize recorder
    _audioRecorder = FlutterSoundRecorder();
    _initializeRecorder();
    
    // Initialize player
    _audioPlayer = AudioPlayer();
    _setupAudioPlayerListeners();
    
    // Check if we're starting with an existing file
    if (widget.existingFilePath != null) {
      _filePath = widget.existingFilePath!;
      _setAudio();
      setState(() {
        _isPlaybackMode = true;
      });
    }
    
    // Setup animation for recording pulse
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  void _setupAudioPlayerListeners() {
    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() => _duration = d);
      }
    });
    
    _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() => _position = p);
      }
    });
    
    _audioPlayer.onPlayerStateChanged.listen((ap.PlayerState s) {
      if (mounted) {
        setState(() => _playerState = s);
      }
    });
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
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
    String path = '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

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
    
    // Switch to playback mode and initialize audio player with the recording
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _stopTimer();
      _isPlaybackMode = true;
    });
    
    _setAudio();
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

  void _setAudio() async {
    await _audioPlayer.setSource(DeviceFileSource(_filePath));
  }

  void _playPause() {
    if (_playerState == ap.PlayerState.playing) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(DeviceFileSource(_filePath));
    }
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
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

  void _resetToRecording() {
    _audioPlayer.stop();
    setState(() {
      _isPlaybackMode = false;
      _recordDuration = 0;
    });
  }

  void _generateNotes() async {
    setState(() {
      _isGenerating = true;
    });

    try {
      File audioFile = File(_filePath);
      String extension = _filePath.split('.').last;
      String mimeType = _getMimeType(extension);

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'file',
        audioFile.path,
        contentType: MediaType.parse(mimeType),
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://bc2d-185-154-158-212.ngrok-free.app/transcribe'),
      );
      request.files.add(multipartFile);
      request.fields['mode'] = _selectedMode; 

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

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder?.closeRecorder();
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildRecordingUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated Wave Visualization
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: 220,
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 30),
              child: CustomPaint(
                painter: WaveformPainter(
                  progress: _animationController.value,
                  color: _isRecording && !_isPaused 
                      ? Color.fromARGB(255, 255, 17, 0)
                      : Color.fromARGB(255, 123, 42, 185),
                  active: _isRecording && !_isPaused,
                ),
              ),
            );
          },
        ),
        
        // Time Display
        Text(
          _formatTime(_recordDuration),
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 123, 42, 185),
            fontFamily: 'Horizon',
          ),
        ),
        SizedBox(height: 20),
        
        // Recording Button
        Material(
          shape: CircleBorder(),
          elevation: 6,
          shadowColor: Colors.black26,
          child: InkWell(
            onTap: () {
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
            customBorder: CircleBorder(),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording && !_isPaused
                    ? Color.fromARGB(255, 255, 17, 0)
                    : Color.fromARGB(255, 123, 42, 185),
              ),
              child: Icon(
                _isRecording && !_isPaused ? Icons.pause : Icons.mic,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        
        // Stop Button - Only visible when recording
        if (_isRecording)
          ElevatedButton.icon(
            onPressed: _stopRecording,
            icon: Icon(Icons.stop_circle_outlined),
            label: Text('Stop & Preview', style: TextStyle(fontSize: 16)),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 123, 42, 185),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaybackUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Playback Waveform Visualization
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 120,
          margin: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 238, 222, 255),
            borderRadius: BorderRadius.circular(15),
          ),
          child: CustomPaint(
            painter: PlaybackWaveformPainter(
              progress: _position.inMilliseconds / 
                (_duration.inMilliseconds > 0 ? _duration.inMilliseconds : 1),
              color: Color.fromARGB(255, 123, 42, 185),
            ),
          ),
        ),
        
        // Playback Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Rewind 10 seconds
            IconButton(
              icon: Icon(Icons.replay_10, size: 36),
              onPressed: () {
                final newPosition = _position - Duration(seconds: 10);
                _audioPlayer.seek(newPosition.isNegative ? Duration.zero : newPosition);
              },
              color: Color.fromARGB(255, 56, 55, 55),
            ),
            
            // Play/Pause Button
            Material(
  shape: CircleBorder(),
  elevation: 6,
  shadowColor: Colors.black26,
  child: InkWell(
    onTap: _playPause,
    customBorder: CircleBorder(),
    child: Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 123, 42, 185),
      ),
      child: Icon(
        _playerState == ap.PlayerState.playing
            ? Icons.pause
            : Icons.play_arrow,
        size: 40,
        color: Colors.white,
      ),
    ),
  ),
),

            // Forward 10 seconds
            IconButton(
              icon: Icon(Icons.forward_10, size: 36),
              onPressed: () {
                final newPosition = _position + Duration(seconds: 10);
                _audioPlayer.seek(newPosition > _duration ? _duration : newPosition);
              },
              color: Color.fromARGB(255, 56, 55, 55),
            ),
          ],
        ),
        SizedBox(height: 10),
        
        // Slider and Time Display
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Slider(
                min: 0,
                max: _duration.inSeconds.toDouble(),
                value: _position.inSeconds.clamp(0, _duration.inSeconds).toDouble(),
                onChanged: (double value) {
                  _audioPlayer.seek(Duration(seconds: value.toInt()));
                },
                activeColor: Color.fromARGB(255, 123, 42, 185),
                inactiveColor: Color.fromARGB(255, 238, 222, 255),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position)),
                    Text(_formatDuration(_duration)),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 35),
        
        // Mode Selection and Generate Notes Button
        Container(
          width: 310,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 238, 222, 255),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [


              Container(
                width: 250,
height: 50,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
    border: Border.all(
      color: Color.fromARGB(255, 255, 255, 255),
      width: 1.5,
    ),
  ),
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: _selectedMode,
      icon: Icon(Icons.arrow_drop_down, color: Color.fromARGB(255, 123, 42, 185)),
      isExpanded: true,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
      items: _modes.map((String mode) {
        return DropdownMenuItem<String>(
          value: mode,
          child: Text(mode),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedMode = newValue!;
        });
      },
    ),
  ),
),

              SizedBox(height: 16),
              _isGenerating
                  ? Column(
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromARGB(255, 123, 42, 185),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Generating Notes, please wait...'),
                      ],
                    )
                  : ElevatedButton.icon(
                      onPressed: _generateNotes,
                      icon: Icon(Icons.auto_awesome),
                      label: Text('Generate Notes', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 123, 42, 185),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(height: 20),
        
        // Record New Button
        TextButton.icon(
          onPressed: _resetToRecording,
          icon: Icon(Icons.fiber_new),
          label: Text('Record New Audio'),
          style: TextButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 123, 42, 185),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Scaffold(   
        backgroundColor: Colors.white,     body: SafeArea(
          child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mode Indicator
                  Row(
                    children: [
                      Stack(
                            children: [
                              // The circle background
                              Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 221, 202, 255), // background circle color
                                ),
                              ),
                      
                              // The icon on top of the circle
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 20, // slightly smaller to fit in the circle
                                      color: mainColor, // the icon color
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
SizedBox(width: 17,),
                          Text(
                    _isPlaybackMode ? 'Playback Mode' : 'Recording Mode',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Jersey10',
                      fontSize: 40,
                      color: Color.fromARGB(255, 123, 42, 185),
                    ),
                  ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(color: const Color.fromARGB(255, 104, 104, 104)),
                      
            
                // Main Content Area
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SingleChildScrollView(
                        child: _isPlaybackMode
                            ? _buildPlaybackUI()
                            : _buildRecordingUI(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Recording Waveform Animation
class WaveformPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool active;

  WaveformPainter({
    required this.progress,
    required this.color,
    required this.active,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;
    final centerY = height / 2;
    
    // Draw waveform based on activity
    if (active) {
      for (int i = 0; i < width; i += 5) {
        // Create dynamic height based on position and progress
        final normalizedI = i / width;
        final sinValue = sin((normalizedI * 10) + (progress * 10));
        final amplitude = active ? 20.0 + (30.0 * sinValue.abs()) : 5.0;
        
        canvas.drawLine(
          Offset(i.toDouble(), centerY - amplitude),
          Offset(i.toDouble(), centerY + amplitude),
          paint,
        );
      }
    } else {
      // Draw flat line with small variations when inactive
      for (int i = 0; i < width; i += 8) {
        final amplitude = 5.0 + (progress * 3.0);
        canvas.drawLine(
          Offset(i.toDouble(), centerY - amplitude),
          Offset(i.toDouble(), centerY + amplitude),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.color != color ||
           oldDelegate.active != active;
  }
}

// Custom Painter for Playback Waveform Visualization
class PlaybackWaveformPainter extends CustomPainter {
  final double progress;
  final Color color;

  PlaybackWaveformPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final activeBarPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final inactiveBarPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final width = size.width;
    final height = size.height;
    final centerY = height / 2;
    final progressWidth = width * progress;
    
    // Draw audio visualization bars
    final random = List.generate(100, (index) => (index % 7) * 0.15);
    
    for (int i = 0; i < width; i += 5) {
      final normalizedI = i / width;
      final randomIndex = (normalizedI * random.length).floor() % random.length;
      final randomValue = random[randomIndex];
      
      // Vary bar heights based on position
      final barHeight = 10.0 + (height * 0.4 * randomValue);
      
      canvas.drawLine(
        Offset(i.toDouble(), centerY - barHeight),
        Offset(i.toDouble(), centerY + barHeight),
        i <= progressWidth ? activeBarPaint : inactiveBarPaint,
      );
    }
  }

  @override
  bool shouldRepaint(PlaybackWaveformPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}