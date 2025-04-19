import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MessageScreen(),
    );
  }
}

// Message Model
class MessageModel {
  final String patientId;
  final String patientName;
  final String lastMessage;
  final DateTime timestamp;
  final bool isRead;
  final String avatarColor;

  MessageModel({
    required this.patientId,
    required this.patientName,
    required this.lastMessage,
    required this.timestamp,
    this.isRead = false,
    this.avatarColor = '#3498db', // Default blue color
  });
}

// Message Screen
class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // Mock data with avatar colors
  final List<MessageModel> _messages = [
    MessageModel(
      patientId: 'P001',
      patientName: 'John Doe',
      lastMessage: 'Can we discuss my recent test results?',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      avatarColor: '#3498db', // Blue
    ),
    MessageModel(
      patientId: 'P002',
      patientName: 'Jane Smith',
      lastMessage: 'I have some questions about my medication.',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: true,
      avatarColor: '#2ecc71', // Green
    ),
    MessageModel(
      patientId: 'P003',
      patientName: 'Mike Johnson',
      lastMessage: 'When is my next appointment?',
      timestamp: DateTime.now(),
      isRead: false,
      avatarColor: '#e74c3c', // Red
    ),
  ];

  // Timestamp formatting
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    if (now.day == timestamp.day) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (now.difference(timestamp).inDays < 7) {
      return DateFormat('EEE').format(timestamp);
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  // Navigate to chat screen with transition
  void _navigateToChatScreen(MessageModel message) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DetailedChatScreen(
          patientId: message.patientId,
          patientName: message.patientName,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          'Patient Messages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black87),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PatientSearchDelegate(_messages),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey.shade200,
          indent: 80,
        ),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(int.parse(message.avatarColor.replaceFirst('#', '0xff'))),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Color(int.parse(message.avatarColor.replaceFirst('#', '0xff'))).withOpacity(0.2),
                  child: Text(
                    message.patientName[0].toUpperCase(),
                    style: TextStyle(
                      color: Color(int.parse(message.avatarColor.replaceFirst('#', '0xff'))),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Text(
                message.patientName,
                style: TextStyle(
                  fontWeight: message.isRead ? FontWeight.w500 : FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                message.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: message.isRead ? Colors.grey.shade600 : Colors.black87,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatTimestamp(message.timestamp),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (!message.isRead)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Color(int.parse(message.avatarColor.replaceFirst('#', '0xff'))),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              onTap: () => _navigateToChatScreen(message),
            ),
          );
        },
      ),
    );
  }
}

// Search Delegate
class PatientSearchDelegate extends SearchDelegate<MessageModel?> {
  final List<MessageModel> messages;

  PatientSearchDelegate(this.messages);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = messages.where((message) =>
        message.patientName.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final message = results[index];
        return ListTile(
          title: Text(message.patientName),
          subtitle: Text(message.lastMessage),
          onTap: () {
            close(context, message);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = messages.where((message) =>
        message.patientName.toLowerCase().contains(query.toLowerCase())
    ).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final message = suggestions[index];
        return ListTile(
          title: Text(message.patientName),
          subtitle: Text(message.lastMessage),
          onTap: () {
            query = message.patientName;
            showResults(context);
          },
        );
      },
    );
  }
}

// Detailed Chat Screen
class DetailedChatScreen extends StatefulWidget {
  final String patientId;
  final String patientName;

  const DetailedChatScreen({
    Key? key,
    required this.patientId,
    required this.patientName
  }) : super(key: key);

  @override
  _DetailedChatScreenState createState() => _DetailedChatScreenState();
}

class _DetailedChatScreenState extends State<DetailedChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {
      'text': "Hello, dr. turner, i've been dealing with sudden acne breakouts and oily skin. i also noticed some weight gain and irregular cycles. could this be hormonal?",
      'sender': 'patient',
      'time': '09:40'
    },
    {
      'text': "Hello, yes, hormonal imbalances, particularly related to conditions like PCOS or thyroid disorders, can impact your skin and metabolism. How recently have you noticed these symptoms? Are there any other symptoms like fatigue or hair thinning?",
      'sender': 'doctor',
      'time': '09:41'
    },
    {
      'text': "yes, i've been feeling more tired than usual, and i've noticed some hair fall. my diet has been inconsistent due to my work schedule.",
      'sender': 'patient',
      'time': '09:43'
    },
    {
      'text': "that sounds great. how do i book these tests?",
      'sender': 'patient',
      'time': '09:56'
    },
    {
      'text': "I'll upload a test prescription to your medcloser. You can book from the nearby lab, once the results are available, we'll review them and plan the next steps together.",
      'sender': 'doctor',
      'time': '09:58'
    },
    {
      'text': "thank you dr. turner. i really appreciate your guidance.",
      'sender': 'patient',
      'time': '10:00'
    }
  ];

  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                widget.patientName[0].toUpperCase(),
                style: TextStyle(color: Colors.blue),
              ),
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.patientName, style: TextStyle(fontSize: 16)),
                Text('Online', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call, color: Colors.white),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(messages[index]);
              },
            ),
          ),
          _buildMessageInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isDoctor = message['sender'] == 'doctor';
    return Align(
      alignment: isDoctor ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isDoctor ? Colors.blue[50] : Colors.blue,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isDoctor ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(height: 5),
            Text(
              message['time'],
              style: TextStyle(
                fontSize: 10,
                color: isDoctor ? Colors.black54 : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInputArea() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.blue),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Write Here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.mic, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              // Add message sending logic here
              if (_messageController.text.isNotEmpty) {
                setState(() {
                  messages.add({
                    'text': _messageController.text,
                    'sender': 'patient',
                    'time': DateFormat('HH:mm').format(DateTime.now())
                  });
                  _messageController.clear();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}