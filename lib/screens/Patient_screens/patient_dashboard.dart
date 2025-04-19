import 'package:flutter/material.dart';
import 'package:intel/screens/Patient_screens/chatbot_screen.dart';
import 'package:intel/screens/Patient_screens/diet_plan_screen.dart';
import 'package:intel/screens/Patient_screens/my_dosage_schedule_screen.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:intel/screens/Patient_screens/patient_doc_appointment_screen.dart';
import 'package:intel/screens/Patient_screens/labtests_screen.dart';
import 'package:intel/screens/Patient_screens/medical_history_screen.dart';
import 'package:intel/screens/Patient_screens/symptomdoc_screen.dart';
import 'package:intel/screens/Patient_screens/telemedicine_screen.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({Key? key}) : super(key: key);
  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}
class _PatientDashboardState extends State<PatientDashboard> with TickerProviderStateMixin {
  late AnimationController _floatingButtonController;
  late AnimationController _cardAnimationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _bookAnimationController;
  late Animation<double> _bookRotationAnimation;
  late AnimationController _dietPlanAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  @override
  void initState() {
    super.initState();
    _floatingButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    _bookAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
    _bookRotationAnimation = Tween<double>(begin: 0.05, end: 0.0).animate(
      CurvedAnimation(
        parent: _bookAnimationController,
        curve: Curves.elasticOut,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.easeOutBack,
      ),
    );
    _dietPlanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  @override
  void dispose() {
    _floatingButtonController.dispose();
    _cardAnimationController.dispose();
    _bookAnimationController.dispose();
    _dietPlanAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }
  final Map<String, String> patientInfo = {
    'name': 'Alice Johnson',
    'id': 'PT-78562',
    'age': '32',
    'bloodGroup': 'O+',
    'email': 'alice.j@example.com',
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEEF5FF), Color(0xFFE0ECFF), Color(0xFFD8E8FF)],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              right: -100,
              child: AnimatedBuilder(
                animation: _floatingButtonController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _floatingButtonController.value * 0.05,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF4285F4).withOpacity(0.25),
                            const Color(0xFF4285F4).withOpacity(0.05),
                          ],
                          stops: const [0.3, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: AnimatedBuilder(
                animation: _floatingButtonController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _floatingButtonController.value * 0.1,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF4285F4).withOpacity(0.18),
                            const Color(0xFF4285F4).withOpacity(0.02),
                          ],
                          stops: const [0.2, 1.0],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 150,
              right: -40,
              child: AnimatedBuilder(
                animation: _dietPlanAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _dietPlanAnimationController.value * 0.08,
                    child: Opacity(
                      opacity: 0.12,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF0F9D58).withOpacity(0.5),
                              const Color(0xFF0F9D58).withOpacity(0.0),
                            ],
                            stops: const [0.2, 1.0],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _cardAnimationController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _scaleAnimation.value,
                            child: child,
                          );
                        },
                        child: buildHeader(),
                      ),
                      const SizedBox(height: 24),
                      FadeTransition(
                        opacity: _cardAnimationController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.1),
                            end: Offset.zero,
                          ).animate(_cardAnimationController),
                          child: buildSectionHeader('Medical History'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _cardAnimationController,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(_cardAnimationController),
                          child: buildBookStackMedicalHistory(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      buildSectionHeader('Schedule Appointments'),
                      const SizedBox(height: 12),
                      buildDoctorAppointments(),
                      const SizedBox(height: 24),
                      buildSectionHeader('Healthcare Services'),
                      const SizedBox(height: 12),
                      buildEnhancedAIDietPlan(context ),
                      const SizedBox(height: 16),
                      buildHealthServicesGrid(),
                      const SizedBox(height: 24),
                      buildSectionHeader('My Dosage Schedule'),
                      const SizedBox(height: 12),
                      buildDosageSchedule(),
                      const SizedBox(height: 24),
                      buildSectionHeader('My Recent Lab Tests'),
                      const SizedBox(height: 12),
                      buildLabTests(),
                      const SizedBox(height: 80), // Extra space for chatbot
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: buildChatAssistantButton(),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4285F4), Color(0xFF1A73E8)],
          stops: [0.2, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4285F4).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                // Profile avatar with enhanced effects
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF4285F4), size: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello ${patientInfo['name']?.split(' ')[0]}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Patient details row - enhanced for better readability
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildPatientInfoBadge(
                              'ID: ${patientInfo['id']?.toString() ?? ''}',
                              Icons.badge_outlined,
                            ),
                            const SizedBox(width: 6),
                            _buildPatientInfoBadge(
                              'Age: ${patientInfo['age']?.toString() ?? ''}',
                              Icons.calendar_today,
                            ),
                            const SizedBox(width: 6),
                            _buildPatientInfoBadge(
                              'Blood: ${patientInfo['bloodGroup']?.toString() ?? ''}',
                              Icons.bloodtype_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Email with enhanced badge
                      _buildPatientInfoBadge(
                        '${patientInfo['email']}',
                        Icons.email_outlined,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildPatientInfoBadge(String text, IconData icon, {bool isFullWidth = false}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: isFullWidth ? double.infinity : 110,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // ENHANCED BOOK STACK MEDICAL HISTORY
  Widget buildBookStackMedicalHistory() {
    // List of medical conditions to display as books
    final List<Map<String, dynamic>> medicalRecords = [
      {
        'condition': 'Bronchitis',
        'status': 'Completed Treatment',
        'icon': Icons.medical_services_outlined,
        'color': const Color(0xFF4285F4),
        'spine_color': const Color(0xFF3367D6),
        'pages_color': Colors.white,
      },
      {
        'condition': 'Hypertension',
        'status': 'Under Control',
        'icon': Icons.favorite_border,
        'color': const Color(0xFF0F9D58),
        'spine_color': const Color(0xFF0B8043),
        'pages_color': const Color(0xFFF8F9FA),
      },
      {
        'condition': 'Allergy',
        'status': 'Seasonal',
        'icon': Icons.air,
        'color': const Color(0xFFDB4437),
        'spine_color': const Color(0xFFC5221F),
        'pages_color': const Color(0xFFFFF8E1),
      },
    ];
    return Container(
      height: 240,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(medicalRecords.length, (index) {
          // Reverse the list so the top book is the last item
          final recordIndex = medicalRecords.length - 1 - index;
          final record = medicalRecords[recordIndex];
          // Calculate a stagger for the books
          final yOffset = recordIndex * 25.0;
          final xOffset = recordIndex * 10.0;
          final rotationZ = recordIndex * 0.05;
          return AnimatedBuilder(
            animation: _bookAnimationController,
            builder: (context, child) {
              // Stagger the animation timing
              final delay = 0.2 * recordIndex;
              final animationValue = (_bookAnimationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay);
              // Add a small bounce effect
              final bounce = math.sin(animationValue * math.pi) * 5 * (1 - recordIndex * 0.3);
              return Positioned(
                left: xOffset,
                bottom: yOffset - bounce,
                right: -xOffset,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..rotateZ((rotationZ - _bookRotationAnimation.value * recordIndex) * (1 - animationValue * 0.7))
                    ..rotateX(0.1 * (1 - animationValue)),
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: animationValue,
                    child: child,
                  ),
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                // Add an interactive bounce effect when tapped
                _bookAnimationController.reset();
                _bookAnimationController.forward();
              },
              child: _buildEnhancedBookCard(
                record['condition'],
                record['status'],
                record['icon'],
                record['color'],
                record['spine_color'],
                record['pages_color'],
                recordIndex,
              ),
            ),
          );
        }),
      ),
    );
  }
  Widget _buildEnhancedBookCard(
      String condition,
      String status,
      IconData icon,
      Color color,
      Color spineColor,
      Color pagesColor,
      int index
      ) {
    return GestureDetector(
      onTap: () {
        // Navigate to the MedicalHistoryScreen when a book is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalHistoryScreen(),
          ),
        );
      },
      child: SizedBox(
        height: 180,
        child: Stack(
          children: [
            // Enhanced shadow for 3D effect
            Positioned(
              right: 5,
              top: 10,
              bottom: 0,
              left: 30,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
              ),
            ),
            // Book pages - slightly rotated to give 3D look
            Transform(
              alignment: Alignment.centerLeft,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateY(0.05), // Slight tilt
              child: Container(
                width: double.infinity,
                height: 180,
                margin: const EdgeInsets.only(left: 20, right: 10),
                decoration: BoxDecoration(
                  color: pagesColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                    topLeft: Radius.circular(2),
                    bottomLeft: Radius.circular(2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(3, 3),
                    ),
                  ],
                ),
                // Book page lines for details
                child: Stack(
                  children: [
                    // Enhanced page decorations - lines with subtle gradient
                    Positioned(
                      top: 40,
                      left: 30,
                      right: 20,
                      bottom: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          7,
                              (lineIndex) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    color.withOpacity(0.15),
                                    color.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Enhanced book content with better typography and details
                    Positioned(
                      top: 0,
                      left: 30,
                      right: 15,
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  condition,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    icon,
                                    color: color,
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: color.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  color: color.withOpacity(0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withOpacity(0.2),
                                        blurRadius: 5,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: color,
                                    size: 16,
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
            ),
            // Enhanced book spine with texture
            Stack(
              children: [
                // Shadow for spine
                Container(
                  width: 20,
                  height: 180,
                  decoration: BoxDecoration(
                    color: spineColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(2, 0),
                      ),
                    ],
                  ),
                ),
                // Spine texture overlay
                Container(
                  width: 20,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                        Colors.white.withOpacity(0.05),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.6, 1.0],
                    ),
                  ),
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Center(
                      child: Text(
                        condition.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Enhanced book edge with pages texture
            Positioned(
              top: 0,
              bottom: 0,
              right: 10,
              child: Container(
                width: 3,
                decoration: BoxDecoration(
                  color: pagesColor.withOpacity(0.8),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(3),
                    bottomRight: Radius.circular(3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(
                    15,
                        (i) => Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: i % 2 == 0
                            ? pagesColor.withOpacity(0.9)
                            : pagesColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4285F4), Color(0xFF1A73E8)],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4285F4).withOpacity(0.3),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202124),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildDoctorAppointments() {
    final doctors = [
      {
        'name': 'Dr. Sarah Johnson',
        'specialty': 'Cardiologist',
        'experience': '3 Years',
        'rating': 4.8,
        'avatar': Icons.person, // In a real app, this would be an image
      },
      {
        'name': 'Dr. Michael Lee',
        'specialty': 'Neurologist',
        'experience': '5 Years',
        'rating': 4.9,
        'avatar': Icons.person, // In a real app, this would be an image
      },
    ];
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorAppointmentScreen(),
                ),
              );
            },
            child: Container(
              width: 300,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 12,
                right: index == doctors.length - 1 ? 0 : 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4).withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF4285F4),
                        child: Icon(
                          doctor['avatar'] as IconData,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            doctor['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF202124),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            doctor['specialty'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF5F6368),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildDoctorInfoBadge(
                                '${doctor['experience']}',
                                Icons.access_time,
                              ),
                              const SizedBox(width: 8),
                              _buildDoctorInfoBadge(
                                '${doctor['rating']}',
                                Icons.star,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4285F4),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4285F4).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildDoctorInfoBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF5FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF4285F4), size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4285F4),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  Widget buildEnhancedAIDietPlan(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DietPlanScreen()), // Replace with your actual screen
        );
      },
      child: AnimatedBuilder(
        animation: _dietPlanAnimationController,
        builder: (context, child) {
          final pulseValue = math.sin(_dietPlanAnimationController.value * math.pi) * 0.02 + 1.0;
          return Transform.scale(
            scale: pulseValue,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F9D58), Color(0xFF0B8043)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F9D58).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: _dietPlanAnimationController.value * 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Personalized Diet Plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Get personalized meal plans based on your health data and preferences.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildHealthServicesGrid() {
    final services = [
      {
        'title': 'Telemedicine',
        'icon': Icons.video_call,
        'color': const Color(0xFF4285F4),
        'route': const  TelemedicineScreen(),
      },
      {
        'title': 'Lab Tests',
        'icon': Icons.science,
        'color': const Color(0xFFDB4437),
        'route': const LabTestsScreen(),
      },
      {
        'title': 'SymptomDoc',
        'icon': Icons.health_and_safety,
        'color': const Color(0xFF0F9D58),
        'route': SymptomAnalysisPage(),
      },
    ];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => service['route'] as Widget,
              ),
            );
          },
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              // Add a small delay for each item
              final delayedValue = (_pulseAnimationController.value - (index * 0.2))
                  .clamp(0.0, 1.0);
              final scale = 1.0 + (delayedValue > 0.5 ? _pulseAnimation.value - 1.0 : 0.0) * 0.5;
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: service['color'] as Color == const Color(0xFF4285F4)
                        ? const Color(0xFF4285F4).withOpacity(0.15)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (service['color'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      service['icon'] as IconData,
                      color: service['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service['title'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202124),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  Widget buildDosageSchedule() {
    final medications = [
      {
        'name': 'Lisinopril',
        'dosage': '10mg',
        'time': '08:00 AM',
        'status': 'Taken',
        'icon': Icons.check_circle,
        'statusColor': const Color(0xFF0F9D58),
      },
      {
        'name': 'Atorvastatin',
        'dosage': '20mg',
        'time': '09:00 PM',
        'status': 'Pending',
        'icon': Icons.access_time,
        'statusColor': const Color(0xFFF4B400),
      },
    ];
    return GestureDetector(
      onTap: () {
        // Navigate to the dosage schedule screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PrescriptionsScreen(),
          ),
        );
      },
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return AnimatedBuilder(
            animation: _cardAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.medication,
                      color: Color(0xFF4285F4),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF202124),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          medication['dosage'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5F6368),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        medication['time'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF5F6368),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            medication['icon'] as IconData,
                            color: medication['statusColor'] as Color,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            medication['status'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: medication['statusColor'] as Color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildLabTests() {
    final tests = [
      {
        'name': 'Complete Blood Count',
        'date': 'March 15, 2023',
        'status': 'Completed',
        'result': 'Normal',
        'resultColor': const Color(0xFF0F9D58),
      },
      {
        'name': 'Lipid Panel',
        'date': 'March 10, 2023',
        'status': 'Completed',
        'result': 'High Cholesterol',
        'resultColor': const Color(0xFFDB4437),
      },
    ];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: tests.length,
      itemBuilder: (context, index) {
        final test = tests[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    test['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF202124),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (test['resultColor'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      test['result'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: test['resultColor'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    test['date'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                  Text(
                    test['status'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
  Widget buildChatAssistantButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Chatbot()),
        );
      },
      child: AnimatedBuilder(
        animation: _floatingButtonController,
        builder: (context, child) {
          final scale = 1.0 + math.sin(_floatingButtonController.value * math.pi) * 0.05;
          return Transform.scale(
            scale: scale,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4285F4).withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF4285F4),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.chat,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



