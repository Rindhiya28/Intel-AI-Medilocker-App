import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intel/screens/Patient_screens/patient_doc_appointment_screen.dart';

class DoctorRecommendationScreen extends StatefulWidget {
  final Map<String, dynamic> patientRecord;

  const DoctorRecommendationScreen({Key? key, required this.patientRecord}) : super(key: key);

  @override
  _DoctorRecommendationScreenState createState() => _DoctorRecommendationScreenState();
}

class _DoctorRecommendationScreenState extends State<DoctorRecommendationScreen> {
  late List<Map<String, dynamic>> _recommendedDoctors;

  @override
  void initState() {
    super.initState();
    _recommendedDoctors = _findRecommendedDoctors();
  }

  List<Map<String, dynamic>> _findRecommendedDoctors() {
    // Same implementation as before
    List<String> patientSymptoms = widget.patientRecord['symptoms'];

    List<Map<String, dynamic>> exactMatches = _allDoctors.where((doctor) {
      return doctor['symptoms'].any((symptom) =>
          patientSymptoms.contains(symptom.toString().toLowerCase()));
    }).toList();

    if (exactMatches.isEmpty) {
      exactMatches = _allDoctors.where((doctor) {
        return patientSymptoms.any((patientSymptom) =>
            doctor['symptoms'].any((doctorSymptom) =>
                doctorSymptom.toString().toLowerCase().contains(patientSymptom.toLowerCase())));
      }).toList();
    }

    if (exactMatches.isEmpty) {
      exactMatches = _allDoctors.where((doctor) =>
      doctor['specialty'] == 'General Practitioner' ||
          doctor['specialty'] == 'Internal Medicine').toList();
    }

    exactMatches.sort((a, b) => b['rating'].compareTo(a['rating']));

    return exactMatches.take(5).toList();
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor) {
    return Animate(
      effects: [
        FadeEffect(duration: 500.ms),
        SlideEffect(
          begin: const Offset(0.5, 0),
          end: Offset.zero,
          duration: 500.ms,
        ),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: 'doctor_avatar_${doctor['name']}',
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.3),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: Colors.blue,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              doctor['specialty'],
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassChip(
                        icon: Icons.star,
                        text: '${doctor['rating']} (${doctor['reviews']} reviews)',
                        color: Colors.amber,
                      ),
                      _buildGlassChip(
                        icon: Icons.work,
                        text: '${doctor['experience']} Exp.',
                        color: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              DoctorAppointmentScreen(),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            );
                          },
                        ),
                      ),
                      icon: const Icon(Icons.calendar_month),
                      label: const Text('Book Appointment'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildGlassChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Recommended Doctors',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade600,
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Column(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Based on your symptoms: ${widget.patientRecord['symptoms'].join(", ")}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                child: _recommendedDoctors.isNotEmpty
                    ? ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: _recommendedDoctors.length,
                  itemBuilder: (context, index) {
                    return _buildDoctorCard(_recommendedDoctors[index]);
                  },
                )
                    : const Center(
                  child: Text(
                    'No doctors found matching your symptoms',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
final List<Map<String, dynamic>> _allDoctors = [];