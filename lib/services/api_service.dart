import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  static Future<String> generateNotes(String audioFilePath) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$API_BASE_URL/transcribe'),
    );
    request.files.add(
      await http.MultipartFile.fromPath('file', audioFilePath),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return responseData;
    } else {
      throw Exception('Failed to generate notes');
    }
  }
}
