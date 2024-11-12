import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class AudioProvider extends ChangeNotifier {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecorderInitialized = false;
  bool isRecording = false;
  bool isProcessing = false;
  String? notes;

  AudioProvider() {
    _init();
  }

  Future<void> _init() async {
    await _recorder.openRecorder();
    isRecorderInitialized = true;
    notifyListeners();
  }

  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Handle permission denied
      return;
    }

    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/flutter_sound.aac';

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
    );
    isRecording = true;
    notifyListeners();
  }

  Future<void> stopRecording() async {
    if (!isRecorderInitialized) return;

    String? path = await _recorder.stopRecorder();
    isRecording = false;
    notifyListeners();

    if (path != null) {
      File audioFile = File(path);
      await sendAudioFile(audioFile);
    }
  }

  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null && result.files.single.path != null) {
      File audioFile = File(result.files.single.path!);
      await sendAudioFile(audioFile);
    }
  }

  Future<void> sendAudioFile(File audioFile) async {
    isProcessing = true;
    notifyListeners();

    try {
      // Replace with your server URL
      String serverUrl = 'https://your-server.com/api/transcribe';

      var request = http.MultipartRequest('POST', Uri.parse(serverUrl));
      request.files.add(
        await http.MultipartFile.fromPath('file', audioFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        String respStr = await response.stream.bytesToString();
        var data = json.decode(respStr);
        notes = data['notes'];
      } else {
        notes = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      notes = 'Error: $e';
    }

    isProcessing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
