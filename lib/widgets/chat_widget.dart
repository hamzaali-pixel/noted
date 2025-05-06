import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatWidget extends StatefulWidget {
  final String notesContent;
  
  const ChatWidget({Key? key, required this.notesContent}) : super(key: key);

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ChatService _chatService = ChatService();
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final userMessage = _messageController.text.trim();
    
    // Add user message to the chat
    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
    });
    _messageController.clear();

    try {
      // Get previous messages (excluding the one we just added)
      final List<ChatMessage> previousMessages = _messages.length > 1 
      ? _messages.sublist(0, _messages.length - 1) 
      : <ChatMessage>[];
      // Send message with conversation history
      final response = await _chatService.sendMessage(
        userMessage, 
        widget.notesContent,
        previousMessages
      );
      
      // Add AI response to the chat
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Sorry, I couldn't process your request. Please try again.",
          isUser: false
        ));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Color.fromARGB(255, 123, 42, 185);
    final Color secondaryColor = Color.fromARGB(255, 238, 222, 255);
    
    return Column(
      children: [
        Expanded(
          child: _messages.isEmpty
              ? Center(
                  child: Text(
                    'Ask me anything about your notes!',
                    style: TextStyle(color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildMessageBubble(message, primaryColor, secondaryColor);
                  },
                ),
        ),
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                SizedBox(width: 8),
                Text('Thinking...', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        _buildMessageInput(primaryColor),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message, Color primaryColor, Color secondaryColor) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? primaryColor : secondaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(Color primaryColor) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            backgroundColor: primaryColor,
            child: Icon(Icons.send, color: Colors.white),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}