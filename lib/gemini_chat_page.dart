import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rit_grubpoint/services/gemini_service.dart';

class GeminiChatPage extends StatefulWidget {
  const GeminiChatPage({super.key});

  @override
  State<GeminiChatPage> createState() => _GeminiChatPageState();
}

class _GeminiChatPageState extends State<GeminiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name');
    });
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMessages = prefs.getStringList('chat_history');
    if (savedMessages != null) {
      setState(() {
        _messages.addAll(
          savedMessages.map((msg) {
            final parts = msg.split(': ');
            return ChatMessage(
              text: parts[1],
              isUser: parts[0] == (_userName ?? 'User'),
            );
          }),
        );
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'chat_history',
      _messages.map((msg) => '${msg.isUser ? (_userName ?? 'User') : 'Jarvis'}: ${msg.text}').toList(),
    );
  }

  Future<void> sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _isLoading = true;
    });

    try {
      final response = await GeminiService.getResponse(userMessage);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
      await _saveChatHistory();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
        ));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Jarvis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              setState(() {
                _messages.clear();
              });
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('chat_history');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.isUser ? (_userName ?? 'User') : 'Jarvis',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: message.isUser ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}