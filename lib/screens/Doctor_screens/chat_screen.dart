import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
              backgroundImage: NetworkImage('https://example.com/doctor-avatar.jpg'),
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dr. Olivia Turner', style: TextStyle(fontSize: 16)),
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
            },
          ),
        ],
      ),
    );
  }
}