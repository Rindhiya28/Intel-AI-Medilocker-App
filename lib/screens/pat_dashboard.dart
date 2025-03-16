import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Android Com...'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage('https://via.placeholder.com/50'),
                ),
                SizedBox(width: 10),
                Text('Hello Alex!'),
              ],
            ),
            SizedBox(height: 20),

            // Medical History Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Medical History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Image.network('https://via.placeholder.com/150'), // Placeholder for medical history image
                    SizedBox(height: 10),
                    Text('Bronchitis, Hospital Treatment'),
                    Text('09/07/2021 - 10/07/2021'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Schedule Appointments Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Schedule Appointments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Recommended Doctors'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Checkup Schedule'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // AI Diet Plans Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Diet Plans', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Image.network('https://via.placeholder.com/150'), // Placeholder for diet plan image
                    SizedBox(height: 10),
                    Text('Get personalized diet plans based on your goals.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // AI Chat Assistant Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AI Chat Assistant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Image.network('https://via.placeholder.com/150'), // Placeholder for chat assistant image
                    SizedBox(height: 10),
                    Text('Chat with our AI assistant for quick guidance.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // My Checkup Schedule Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Checkup Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('https://via.placeholder.com/50'),
                            ),
                            title: Text('Dr. John Doe'),
                            subtitle: Text('Cardiologist'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage('https://via.placeholder.com/50'),
                            ),
                            title: Text('Dr. Jane Smith'),
                            subtitle: Text('Dermatologist'),
                          ),
                        ),
                      ],
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
}