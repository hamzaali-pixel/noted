import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ChatService {
  final String baseUrl = 'https://bc2d-185-154-158-212.ngrok-free.app'; // Change to your API URL

  Future<String> sendMessage(String message, String notesContext, List<ChatMessage> previousMessages) async {
    try {
      // Only include the last 5 messages to maintain a reasonable context window
      final recentMessages = previousMessages.length > 5 
          ? previousMessages.sublist(previousMessages.length - 5) 
          : previousMessages;
      
      // Format the conversation history as a string
      final conversationHistory = recentMessages.map((msg) {
        return "${msg.isUser ? 'User' : 'Assistant'}: ${msg.text}";
      }).join('\n');
      
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        body: {
          'message': message,
          'context': notesContext,
          'conversation_history': conversationHistory,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['response'];
      } else {
        throw Exception('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error communicating with AI service: $e');
    }
  }
}