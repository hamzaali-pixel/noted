// import 'package:flutter/material.dart';
// import '../models/chat_message.dart';
// import '../services/chat_service.dart';

// class ChatWidget extends StatefulWidget {
//   final String notesContent;
  
//   const ChatWidget({Key? key, required this.notesContent}) : super(key: key);

//   @override
//   _ChatWidgetState createState() => _ChatWidgetState();
// }

// class _ChatWidgetState extends State<ChatWidget> {
//   final TextEditingController _messageController = TextEditingController();
//   final List<ChatMessage> _messages = [];
//   final ChatService _chatService = ChatService();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _messageController.dispose();
//     super.dispose();
//   }

//   void _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;
    
//     final userMessage = _messageController.text.trim();
    
//     // Add user message to the chat
//     setState(() {
//       _messages.add(ChatMessage(text: userMessage, isUser: true));
//       _isLoading = true;
//     });
//     _messageController.clear();

//     try {
//       // Get previous messages (excluding the one we just added)
//       final List<ChatMessage> previousMessages = _messages.length > 1 
//       ? _messages.sublist(0, _messages.length - 1) 
//       : <ChatMessage>[];
//       // Send message with conversation history
//       final response = await _chatService.sendMessage(
//         userMessage, 
//         widget.notesContent,
//         previousMessages
//       );
      
//       // Add AI response to the chat
//       setState(() {
//         _messages.add(ChatMessage(text: response, isUser: false));
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add(ChatMessage(
//           text: "Sorry, I couldn't process your request. Please try again.",
//           isUser: false
//         ));
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Color primaryColor = Color.fromARGB(255, 123, 42, 185);
//     final Color secondaryColor = Color.fromARGB(255, 238, 222, 255);
    
//     return Column(
//       children: [
//         Expanded(
//           child: _messages.isEmpty
//               ? Center(
//                   child: Text(
//                     'Ask me anything about your notes!',
//                     style: TextStyle(color: Colors.black54),
//                   ),
//                 )
//               : ListView.builder(
//                   padding: EdgeInsets.all(16),
//                   itemCount: _messages.length,
//                   itemBuilder: (context, index) {
//                     final message = _messages[index];
//                     return _buildMessageBubble(message, primaryColor, secondaryColor);
//                   },
//                 ),
//         ),
//         if (_isLoading)
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 Text('Thinking...', style: TextStyle(color: Colors.black54)),
//               ],
//             ),
//           ),
//         _buildMessageInput(primaryColor),
//       ],
//     );
//   }

//   Widget _buildMessageBubble(ChatMessage message, Color primaryColor, Color secondaryColor) {
//     return Align(
//       alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 4),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: message.isUser ? primaryColor : secondaryColor,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
//         child: Text(
//           message.text,
//           style: TextStyle(
//             color: message.isUser ? Colors.white : primaryColor,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageInput(Color primaryColor) {
//     return Container(
//       padding: EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 4,
//             offset: Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type your question...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//                 contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               ),
//               textInputAction: TextInputAction.send,
//               onSubmitted: (_) => _sendMessage(),
//             ),
//           ),
//           SizedBox(width: 8),
//           FloatingActionButton(
//             mini: true,
//             backgroundColor: primaryColor,
//             child: Icon(Icons.send, color: Colors.white),
//             onPressed: _sendMessage,
//           ),
//         ],
//       ),
//     );
//   }
// }


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
  final ScrollController _scrollController = ScrollController();

  // App theme colors
  final Color _primaryColor = Color.fromARGB(255, 123, 42, 185);
  final Color _secondaryColor = Color.fromARGB(255, 238, 222, 255);

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
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
    
    // Scroll to bottom after adding message
    _scrollToBottom();

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
      
      // Scroll to bottom after getting response
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Sorry, I couldn't process your request. Please try again.",
          isUser: false
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    // Add a small delay to ensure the UI has updated
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            
            // Messages area
            Expanded(
              child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildChatMessages(),
            ),
            
            // Typing indicator
            if (_isLoading)
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Thinking...',
                      style: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            
            // Message input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: _secondaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 50,
              color: _primaryColor,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Ask me anything about your notes!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
            ),
          // ),
          // SizedBox(height: 12),
          // Text(
          //   'I can answer questions, summarize content, or help you understand your notes better.',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.black54,
          //     fontSize: 14,
          //   ),+
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        
        // Add a timestamp between messages that are not from the same sender
        bool showTimestamp = index > 0 && _messages[index - 1].isUser != message.isUser;
        
        return Column(
          children: [
            if (showTimestamp)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Now',
                  style: TextStyle(
                    color: Colors.black38,
                    fontSize: 12,
                  ),
                ),
              ),
            _buildMessageBubble(message),
          ],
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: message.isUser ? 64 : 0,
          right: message.isUser ? 0 : 64,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser ? _primaryColor : _secondaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask a question about your notes...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                textInputAction: TextInputAction.send,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 12),
          Material(
            color: _primaryColor,
            borderRadius: BorderRadius.circular(50),
            child: InkWell(
              onTap: _sendMessage,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}