import 'package:flutter/material.dart';
import 'services/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> get _messages => ChatService.messages;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _isTyping = true;
      ChatService.addMessage({'role': 'user', 'text': text});
    });
    
    _controller.clear();
    _animationController.forward(from: 0.0);
    
    // Simulate typing delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final response = ChatService.getResponse(text);
    setState(() {
      _isTyping = false;
      ChatService.addMessage({'role': 'bot', 'text': response});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (!ChatService.isApiKeyConfigured)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.orange[100],
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        ChatService.getApiKeyWarning(),
                        style: TextStyle(color: Colors.orange[800], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return _buildTypingIndicator();
                  }
                  
                  final msg = _messages[index];
                  final isUser = msg['role'] == 'user';
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isUser ? Colors.deepPurple[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: isUser ? Colors.deepPurple[900] : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Ask about food...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            _buildDot(1),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 200)),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: Colors.grey[600]?.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
} 