import 'package:flutter/material.dart';
import 'package:intel/screens/Doctor_screens/assigned_patients_screen.dart';
import 'package:intel/screens/Doctor_screens/doctor_dashboard.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'package:intel/screens/Doctor_screens/message_screen.dart';
import 'package:intel/screens/Doctor_screens/profile_screen.dart';
import 'package:intel/screens/Doctor_screens/schedule_screen.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final Color primaryColor = const Color(0xFF4285F4);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Stack(
                children: [
                  // Enhanced background gradient with subtle wave pattern
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor.withOpacity(0.1),
                          Colors.white,
                          Colors.white,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  // Decorative background elements
                  Positioned(
                    top: -100,
                    right: -100,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withOpacity(0.03),
                      ),
                    ),
                  ),
                  // Animated wave background
                  Positioned.fill(
                    child: AnimatedWaveBackground(
                      color: primaryColor.withOpacity(0.05),
                      amplitude: 30,
                      frequency: 0.05,
                    ),
                  ),
                  // Main content
                  SafeArea(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                _buildHeader(),
                                const SizedBox(height: 24),
                                _buildEnhancedDoctorProfileCard(),
                                const SizedBox(height: 24),
                                _buildTodaySchedule(),
                                const SizedBox(height: 24),
                                _buildPatientRequestCard(),
                                const SizedBox(height: 24),
                                _buildAppointmentSection(),
                                const SizedBox(height: 24),
                                _buildCalendarView(),
                                const SizedBox(height: 24),
                                PatientStatisticsChart(primaryColor: primaryColor),
                                const SizedBox(height: 80),
                              ],
                            ),
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Dr. John",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        _buildPulsingNotificationIcon(),
      ],
    );
  }

  Widget _buildPulsingNotificationIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: primaryColor.withOpacity(0.1),
      ),
      child: Stack(
        children: [
          Icon(
            Icons.notifications_outlined,
            color: primaryColor,
            size: 24,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.8, end: 1.2),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                      border: Border.all(color: Colors.white, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphicContainer({
    required Widget child,
    double borderRadius = 15,
    double blur = 10,
    Color borderColor = Colors.white,
    Color backgroundColor = Colors.white,
    List<Color>? gradientColors,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withOpacity(0.2),
            ),
            gradient: gradientColors != null
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            )
                : null,
            color: gradientColors == null ? backgroundColor.withOpacity(0.15) : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildEnhancedDoctorProfileCard() {
    return Hero(
      tag: 'doctor-profile',
      child: _buildGlassmorphicContainer(
        borderRadius: 20,
        gradientColors: [
          primaryColor.withOpacity(0.2),
          primaryColor.withOpacity(0.1),
          Colors.white.withOpacity(0.8),
        ],
        borderColor: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              _buildEnhancedAvatarWithBadge(),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dr. John Walker',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Cardiologist specialist',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'ID: 26568984',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Age: 37',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Blood group: B(-)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Email: johnwalker@gmail.com',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: primaryColor.withOpacity(0.1),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            color: primaryColor,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Certified Specialist',
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedAvatarWithBadge() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.7),
                primaryColor,
                primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 53,
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Icon(Icons.person, color: primaryColor, size: 55),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.6),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Schedule:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildScheduleCard(
                icon: Icons.group_outlined,
                title: 'Assigned Patients',
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildScheduleCard(
                icon: Icons.directions_walk_outlined,
                title: 'Walk-In Patients',
                color: primaryColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        if (title == 'Assigned Patients') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssignedPatientsPage(),
            ),
          );
        }
        // Add conditions for other navigation cases if needed
      },
      child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: _buildGlassmorphicContainer(
                gradientColors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                  Colors.white.withOpacity(0.8),
                ],
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.2),
                        ),
                        child: Icon(
                          icon,
                          size: 24,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
  Widget _buildPatientRequestCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCirc,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: _buildGlassmorphicContainer(
            gradientColors: [
              primaryColor.withOpacity(0.2),
              primaryColor.withOpacity(0.1),
              Colors.white.withOpacity(0.8),
            ],
            borderRadius: 20,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.7),
                                  primaryColor.withOpacity(0.3),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(
                              Icons.medical_services_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Patients Request',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.2),
                              primaryColor.withOpacity(0.1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Text(
                          '12 new requests',
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          primaryColor.withOpacity(0.7),
                          primaryColor,
                          primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 24,
                      color: Colors.white,
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

  Widget _buildAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Appointments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Track and manage your patient appointments',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        _buildAppointmentHeader(),
      ],
    );
  }

  Widget _buildAppointmentHeader() {
    return _buildGlassmorphicContainer(
      gradientColors: [
        Colors.white.withOpacity(0.9),
        Colors.white.withOpacity(0.8),
      ],
      borderRadius: 16,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.3),
                    primaryColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'July 2024',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Current month',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const Spacer(),
            _buildAppointmentFilterChips(),
          ],
        ),
      ),
    );
  }
  Widget _buildAppointmentFilterChips() {
    return Row(
      children: [
        _buildAppointmentFilterChip('Week', isSelected: false),
        const SizedBox(width: 8),
        _buildAppointmentFilterChip('Month', isSelected: true),
        const SizedBox(width: 8),
        _buildAppointmentFilterChip('All', isSelected: false),
      ],
    );
  }
  Widget _buildAppointmentFilterChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isSelected
            ? LinearGradient(
          colors: [
            primaryColor.withOpacity(0.7),
            primaryColor,
            primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isSelected ? null : Colors.black.withOpacity(0.05),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: primaryColor.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }
  Widget _buildCalendarView() {
    return _buildGlassmorphicContainer(
      gradientColors: [
        primaryColor.withOpacity(0.1),
        Colors.white.withOpacity(0.9),
      ],
      borderRadius: 24,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            _buildCalendarRow(
              weekday: 'Mon',
              date: '01',
              appointments: 3,
              isToday: false,
            ),
            _buildCalendarRow(
              weekday: 'Tue',
              date: '02',
              appointments: 5,
              isToday: false,
            ),
            _buildCalendarRow(
              weekday: 'Wed',
              date: '03',
              appointments: 4,
              isToday: false,
            ),
            _buildCalendarRow(
              weekday: 'Thu',
              date: '04',
              appointments: 2,
              isToday: true,
            ),
            _buildCalendarRow(
              weekday: 'Fri',
              date: '05',
              appointments: 7,
              isToday: false,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCalendarRow({
    required String weekday,
    required String date,
    required int appointments,
    required bool isToday,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 800 + 100 * int.parse(date)),
        curve: Curves.easeOutQuint,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(20 * (1 - value), 0),
            child: Opacity(
              opacity: value,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: isToday
                      ? LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      primaryColor.withOpacity(0.05),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                      : null,
                  border: isToday
                      ? Border.all(color: primaryColor.withOpacity(0.3), width: 1)
                      : null,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isToday
                            ? LinearGradient(
                          colors: [
                            primaryColor.withOpacity(0.7),
                            primaryColor,
                            primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                            : null,
                        color: isToday ? null : Colors.black.withOpacity(0.05),
                        boxShadow: isToday
                            ? [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weekday,
                            style: TextStyle(
                              fontSize: 10,
                              color: isToday ? Colors.white : Colors.black54,
                            ),
                          ),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.white : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildAppointmentsProgressBar(appointments, isToday),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$appointments',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isToday ? primaryColor : Colors.black87,
                          ),
                        ),
                        Text(
                          'appointments',
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? primaryColor.withOpacity(0.7) : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildAppointmentsProgressBar(int appointments, bool isToday) {
    final double progress = appointments / 10; // Assuming 10 is the max number of appointments per day
    // Generate a gradient based on the number of appointments
    List<Color> gradientColors;
    if (appointments < 3) {
      gradientColors = [
        primaryColor.withOpacity(0.7),
        primaryColor,
        primaryColor.withOpacity(0.8),
      ];
    } else if (appointments < 6) {
      gradientColors = [
        primaryColor.withOpacity(0.7),
        primaryColor,
        primaryColor.withOpacity(0.8),
      ];
    } else {
      gradientColors = [
        Colors.orange.shade300,
        Colors.orange.shade500,
        Colors.orange.shade700,
      ];
    }
    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: progress),
    duration: const Duration(milliseconds: 1500),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Container(
    height: 10,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.black.withOpacity(0.05),
    ),
    child: Stack(
    children: [
    Container(
    height: 10,
    width: MediaQuery.of(context).size.width * value * 0.5,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    gradient: LinearGradient(
    colors: gradientColors,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    ),
    boxShadow: [
    BoxShadow(
    color: gradientColors[1].withOpacity(0.5),
    blurRadius: 4,
    spreadRadius: 0,
    offset: const Offset(0, 2),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
      const SizedBox(height: 4),
      Text(
        isToday ? 'Today\'s schedule' : 'Daily schedule',
        style: TextStyle(
          fontSize: 10,
          color: isToday ? primaryColor.withOpacity(0.7) : Colors.black54,
        ),
      ),
    ],
    );
    });
  }Widget _buildBottomNavigationBar() {
    int _currentIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                    // Navigate to Home Screen
                    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                },
                child: _buildNavItem(Icons.home_rounded, 'Home', isSelected: _currentIndex == 0),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  // Move the navigation outside of setState
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentsScreen())
                  );
                },
                child: _buildNavItem(Icons.calendar_today_rounded, 'Schedule', isSelected: _currentIndex == 1),
              ),
              GestureDetector(
                onTap: () {
                  // Floating Action Button functionality
                  // Example: Show a modal, open a new screen for adding something
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Add New',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildAddOption(Icons.person_add, 'Patient'),
                                _buildAddOption(Icons.calendar_today, 'Appointment'),
                                _buildAddOption(Icons.medical_services, 'Consultation'),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: _buildFloatingNavItem(),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen()));
                  });
                },
                child: _buildNavItem(Icons.message_rounded, 'Messages', isSelected: _currentIndex == 3),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                  // Move the navigation outside of setState
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DoctorProfileDashboard())
                  );
                },
                child: _buildNavItem(Icons.person_rounded, 'Profile', isSelected: _currentIndex == 4),
              ),
            ],
          ),
        );
      },
    );
  }

// Helper method to create add options in the bottom sheet
  Widget _buildAddOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: primaryColor,
          ),
        ),
      ],
    );
  }
  Widget _buildNavItem(IconData icon, String label, {bool isSelected = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          ),
          child: Icon(
            icon,
            color: isSelected ? primaryColor : Colors.black54,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? primaryColor : Colors.black54,
          ),
        ),
      ],
    );
  }
  Widget _buildFloatingNavItem() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.7),
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        );
      },
    );
  }
}
class AnimatedWaveBackground extends StatefulWidget {
  final Color color;
  final double amplitude;
  final double frequency;
  const AnimatedWaveBackground({
    Key? key,
    required this.color,
    required this.amplitude,
    required this.frequency,
  }) : super(key: key);
  @override
  _AnimatedWaveBackgroundState createState() => _AnimatedWaveBackgroundState();
}
class _AnimatedWaveBackgroundState extends State<AnimatedWaveBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(
            color: widget.color,
            amplitude: widget.amplitude,
            frequency: widget.frequency,
            animationValue: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}
class WavePainter extends CustomPainter {
  final Color color;
  final double amplitude;
  final double frequency;
  final double animationValue;
  WavePainter({
    required this.color,
    required this.amplitude,
    required this.frequency,
    required this.animationValue,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, size.height);
    for (var i = 0.0; i <= size.width; i++) {
      final y = size.height -
          amplitude * math.sin((i * frequency) + (animationValue * 2 * math.pi));
      path.lineTo(i, y);
    }
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
class PatientStatisticsChart extends StatelessWidget {
  final Color primaryColor;
  const PatientStatisticsChart({
    Key? key,
    required this.primaryColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Patient Statistics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Overview of your patient visits this month',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SimpleLineChart(primaryColor: primaryColor),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Patients',
                value: '487',
                icon: Icons.person_outline,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Recovery Rate',
                value: '75%',
                icon: Icons.favorite_outline,
                color: Colors.pink.shade400,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Critical Cases',
                value: '24',
                icon: Icons.local_hospital_outlined,
                color: Colors.orange.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
class SimpleLineChart extends StatelessWidget {
  final Color primaryColor;
  const SimpleLineChart({
    Key? key,
    required this.primaryColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: LineChartPainter(primaryColor),
    );
  }
}
class LineChartPainter extends CustomPainter {
  final Color primaryColor;
  LineChartPainter(this.primaryColor);
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    // Sample data points
    final data = [
      0.5, 0.7, 0.4, 0.6, 0.8, 0.6, 0.9, 0.7, 0.8, 0.9, 0.7, 0.8
    ];
    // Paint for the grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    // Draw horizontal grid lines
    for (var i = 0; i <= 4; i++) {
      final y = height * (1 - i / 4);
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    // Draw vertical grid lines
    for (var i = 0; i <= data.length - 1; i++) {
      final x = width * i / (data.length - 1);
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
    }
    // Paint for the line chart
    final linePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    // Path for the line chart
    final path = Path();
    // Path for the area under the line chart
    final areaPath = Path();
    areaPath.moveTo(0, height);
    // Draw the line chart
    for (var i = 0; i < data.length; i++) {
      final x = width * i / (data.length - 1);
      final y = height * (1 - data[i]);
      if (i == 0) {
        path.moveTo(x, y);
        areaPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        areaPath.lineTo(x, y);
      }
      // Draw data points
      canvas.drawCircle(
        Offset(x, y),
        4,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = primaryColor,
      );
    }
    // Finish area path
    areaPath.lineTo(width, height);
    areaPath.close();
    // Draw area under the line chart
    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            primaryColor.withOpacity(0.3),
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, width, height)),
    );
    // Draw the line chart
    canvas.drawPath(path, linePaint);
    // Draw month labels
    const textStyle = TextStyle(
      color: Colors.black54,
      fontSize: 10,
    );
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    for (var i = 0; i < data.length; i++) {
      final x = width * i / (data.length - 1);
      final textSpan = TextSpan(
        text: months[i],
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, height + 5),
      );
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}