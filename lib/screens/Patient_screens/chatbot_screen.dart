import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chatbot extends StatefulWidget {
  const Chatbot({Key? key}) : super(key: key);

  @override
  _ChatbotState createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> with SingleTickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _apiUrl = 'http://192.168.1.35:5000/chat'; // Replace with your Flask server IP
  bool _isLoading = false;
  bool _showDoctorInfo = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  String _professionalName = "Dr. Emma Wilson";
  String _specialization = "Psychiatrist";
  String _contactNumber = "+1-555-012-3456";
  String _email = "emma.wilson@mentalwellness.org";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    Future.delayed(Duration.zero, () {
      _addBotMessage("Hello! I'm your AI-powered mental health companion. How are you feeling today?");
    });
  }

  void _addBotMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: false,
      ));
    });
    _scrollToBottom();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo[700],
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildJourneyHeader(),
                      if (_showDoctorInfo) _buildProfessionalCard(),
                      Flexible(
                        child: _buildChatList(),
                      ),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: LinearProgressIndicator(
                            color: Colors.indigo,
                            backgroundColor: Colors.indigoAccent,
                          ),
                        ),
                      _buildInputArea(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                'Intel-AI Mental',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Text(
            'Health Companion',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your AI-powered support system for mental wellness and emotional guidance.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureItem(Icons.psychology, 'AI-Powered\nSupport'),
              _buildFeatureItem(Icons.lock, 'Confidential'),
              _buildFeatureItem(Icons.monitor_heart, '24/7\nSupport'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.indigo[600],
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30, width: 1),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.red[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended Professional',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _professionalName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[800],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Specialization: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(_specialization, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Contact: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(_contactNumber, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Email: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(_email, style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Please reach out for immediate professional assistance.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Start Your Journey',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              children: [
                Text(
                  '101',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _opacityAnimation,
            child: _messages[index],
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Type your message...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: InputBorder.none,
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan[400],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _isLoading ? null : () => _handleSubmitted(_textController.text),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.mic, color: Colors.cyan[400]),
              onPressed: () {
                // Voice input functionality could be added here
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    ChatMessage userMessage = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });
    _animationController.reset();
    _animationController.forward();
    _scrollToBottom();
    if (_isCrisisMessage(text)) {
      _handleCrisisMessage();
    } else {
      _sendMessageToApi(text);
    }
  }

  bool _isCrisisMessage(String text) {
    text = text.toLowerCase();
    return text.contains('suicide') ||
        text.contains('kill myself') ||
        text.contains('end my life') ||
        text.contains('want to die');
  }

  void _handleCrisisMessage() {
    setState(() {
      _showDoctorInfo = true;
      _messages.add(ChatMessage(
        text: "I'm very concerned to hear that. Please know you are not alone and there are people who want to help. Please call or text 988 (in the US) or your local emergency number immediately. They can provide immediate support and get you the help you need. Your life is valuable, and things can get better. Please reach out for help now.",
        isUser: false,
        isCrisis: true,
      ));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  Future<void> _sendMessageToApi(String message) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': message,
          'user_id': 'test_user', // Replace with dynamic user ID logic if needed
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String botResponse = data['response'] ?? "Sorry, I couldn't process that.";
        setState(() {
          _messages.add(ChatMessage(
            text: botResponse,
            isUser: false,
          ));
          _isLoading = false;
        });
        _scrollToBottom();
      } else {
        setState(() {
          _messages.add(ChatMessage(
            text: "I'm having trouble connecting to my services right now. Could we try again in a moment?",
            isUser: false,
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "I seem to be having connectivity issues. Let's try again when your connection is more stable.",
          isUser: false,
        ));
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final bool isCrisis;

  const ChatMessage({
    Key? key,
    required this.text,
    required this.isUser,
    this.isCrisis = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) _buildAvatar(),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(
                left: isUser ? 60 : 10,
                right: isUser ? 10 : 60,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _getBubbleColor(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (isUser) _buildAvatar(isUser: true),
        ],
      ),
    );
  }

  Color _getBubbleColor() {
    if (isUser) {
      return Colors.cyan[100] ?? Colors.cyan.shade100;
    } else if (isCrisis) {
      return Colors.red[50] ?? Colors.red.shade50;
    } else {
      return Colors.grey[200] ?? Colors.grey.shade200;
    }
  }

  Color _getTextColor() {
    if (isUser) {
      return Colors.black87;
    } else if (isCrisis) {
      return Colors.red[900] ?? Colors.red.shade900;
    } else {
      return Colors.black87;
    }
  }

  Widget _buildAvatar({bool isUser = false}) {
    return CircleAvatar(
      backgroundColor: isUser ? Colors.cyan[400] : Colors.indigo[600],
      child: Icon(
        isUser ? Icons.person : Icons.psychology,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}