// main.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  DateTime selectedDate = DateTime.now();
  List<Appointment> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate fetching data from API
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        appointments = getDummyAppointments();
        isLoading = false;
      });
    });
  }

  void changeDate(DateTime date) {
    setState(() {
      selectedDate = date;
      isLoading = true;
    });
    // Simulate API call with the new date
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        appointments = getDummyAppointments(date: date);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: Column(
        children: [
          // Calendar date selector
          CalendarDateSelector(
            selectedDate: selectedDate,
            onDateChanged: changeDate,
          ),
          // Appointments list
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : appointments.isEmpty
                ? const Center(child: Text('No appointments for this day'))
                : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                return AppointmentCard(appointment: appointments[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Generate dummy appointments for demo purposes
  List<Appointment> getDummyAppointments({DateTime? date}) {
    final targetDate = date ?? DateTime.now();
    // Only return appointments for weekdays (not weekends)
    if (targetDate.weekday == DateTime.saturday || targetDate.weekday == DateTime.sunday) {
      return [];
    }
    // Create different number of appointments based on the day
    final dayFactor = targetDate.day % 5 + 1; // 1-5 appointments
    final List<Appointment> result = [];
    // Starting time: 9:00 AM
    DateTime startTime = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
      9,
      0,
    );
    for (int i = 0; i < dayFactor; i++) {
      // Each appointment is 45 minutes with 15 minutes gap
      final appointmentTime = startTime.add(Duration(hours: i, minutes: i * 15));
      result.add(
        Appointment(
          id: 'APT-${targetDate.day}${targetDate.month}-${i + 1}',
          patientName: _dummyPatientNames[i % _dummyPatientNames.length],
          patientAge: 25 + (i * 5),
          gender: i % 2 == 0 ? 'Male' : 'Female',
          time: appointmentTime,
          reason: _dummyReasons[i % _dummyReasons.length],
          isNewPatient: i % 3 == 0,
        ),
      );
    }
    return result;
  }

  final List<String> _dummyPatientNames = [
    'John Smith',
    'Emma Johnson',
    'Michael Brown',
    'Sarah Davis',
    'Robert Wilson',
    'Jennifer Lee',
  ];

  final List<String> _dummyReasons = [
    'Regular Checkup',
    'Fever and Cough',
    'Blood Test Results',
    'Vaccination',
    'Headache and Dizziness',
    'Follow-up Consultation',
  ];
}

class CalendarDateSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const CalendarDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null && picked != selectedDate) {
                          onDateChanged(picked);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        onDateChanged(
                          selectedDate.subtract(const Duration(days: 1)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        onDateChanged(
                          selectedDate.add(const Duration(days: 1)),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('EEEE, MMMM d').format(selectedDate),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      child: Text(
                        appointment.patientName.substring(0, 1),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              appointment.patientName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (appointment.isNewPatient)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'New',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          '${appointment.patientAge} yrs, ${appointment.gender}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        DateFormat('h:mm a').format(appointment.time),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.id,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          appointment.reason,
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.chat_outlined, size: 16),
                      label: const Text('Message'),
                      onPressed: () {
                        // TODO: Implement messaging functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Messaging functionality not implemented yet.'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('View'),
                      onPressed: () {
                        // Navigate to appointment details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentDetailsScreen(appointment: appointment),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient info card
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          child: Text(
                            appointment.patientName.substring(0, 1),
                            style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    appointment.patientName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (appointment.isNewPatient)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'New Patient',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${appointment.patientAge} years • ${appointment.gender}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Patient ID: ${appointment.id}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildActionButton(
                          context,
                          Icons.phone,
                          'Call',
                          Colors.blue,
                        ),
                        _buildActionButton(
                          context,
                          Icons.message,
                          'Message',
                          Colors.green,
                        ),
                        _buildActionButton(
                          context,
                          Icons.videocam,
                          'Video',
                          Colors.purple,
                        ),
                        _buildActionButton(
                          context,
                          Icons.edit_calendar,
                          'Reschedule',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Appointment details
            const Text(
              'Appointment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      'Date',
                      DateFormat('EEEE, MMMM d, yyyy').format(appointment.time),
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Time',
                      DateFormat('h:mm a').format(appointment.time),
                      Icons.access_time,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Reason',
                      appointment.reason,
                      Icons.medical_services,
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      context,
                      'Status',
                      'Confirmed',
                      Icons.check_circle,
                      valueColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            // Patient history (placeholder)
            const Text(
              'Patient History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: appointment.isNewPatient
                    ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No previous medical records available for this patient.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
                    : Column(
                  children: [
                    _buildHistoryItem(
                      context,
                      'Previous Visit',
                      DateFormat('MMM d, yyyy').format(
                        appointment.time.subtract(const Duration(days: 90)),
                      ),
                      'General Checkup',
                      'Dr. Jessica Chen',
                    ),
                    const Divider(),
                    _buildHistoryItem(
                      context,
                      'Prescription',
                      DateFormat('MMM d, yyyy').format(
                        appointment.time.subtract(const Duration(days: 90)),
                      ),
                      'Amoxicillin 500mg',
                      'Dr. Jessica Chen',
                    ),
                    const Divider(),
                    _buildHistoryItem(
                      context,
                      'Lab Results',
                      DateFormat('MMM d, yyyy').format(
                        appointment.time.subtract(const Duration(days: 85)),
                      ),
                      'Blood Test',
                      'Central Laboratory',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Start appointment functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Starting appointment...'),
                      ),
                    );
                    Future.delayed(Duration.zero, () {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Start Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      IconData icon,
      String label,
      Color color,
      ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label functionality not implemented yet.'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context,
      String label,
      String value,
      IconData icon, {
        Color? valueColor,
      }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
      BuildContext context,
      String type,
      String date,
      String description,
      String doctor,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              type == 'Previous Visit'
                  ? Icons.local_hospital
                  : type == 'Prescription'
                  ? Icons.medication
                  : Icons.science,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage('https://via.placeholder.com/120'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Dr. Sarah Johnson',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Cardiologist',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'This is a placeholder for the doctor\'s profile screen. In a complete app, this would display doctor information, settings, and other account details.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile editing not implemented in this demo'),
                    ),
                  );
                },
                child: const Text('Edit Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Data Models
class Appointment {
  final String id;
  final String patientName;
  final int patientAge;
  final String gender;
  final DateTime time;
  final String reason;
  final bool isNewPatient;

  Appointment({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.gender,
    required this.time,
    required this.reason,
    required this.isNewPatient,
  });
}