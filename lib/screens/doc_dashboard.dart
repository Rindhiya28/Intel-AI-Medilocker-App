import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

void main() => runApp(const MyApp());

// App theme and constants
class AppTheme {
  static const Color primary = Color(0xFF2A5298);
  static const Color secondary = Color(0xFF4EAEFF);
  static const Color background = Color(0xFFF8FAFD);
  static const Color accent = Color(0xFF00C6AE);
  static const Color dangerRed = Color(0xFFFF6B6B);
  static const Color warningYellow = Color(0xFFFFD166);

  static final ThemeData theme = ThemeData(
    primaryColor: primary,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: background,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: primary,
      ),
    ),
  );

  static final BoxShadow cardShadow = BoxShadow(
    color: primary.withOpacity(0.2),
    blurRadius: 15,
    offset: const Offset(0, 5),
  );

  static final BoxShadow softShadow = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 10,
    spreadRadius: 0,
    offset: const Offset(0, 5),
  );

  static final BoxShadow buttonShadow = BoxShadow(
    color: primary.withOpacity(0.3),
    blurRadius: 8,
    offset: const Offset(0, 4),
  );
}

// Data models
class Appointment {
  final int id;
  final String patientName;
  final String time;
  final String type;
  final Color color;
  final String imageUrl;
  final bool isNew;

  const Appointment({
    required this.id,
    required this.patientName,
    required this.time,
    required this.type,
    required this.color,
    required this.imageUrl,
    this.isNew = false,
  });
}

// Sample data
class AppointmentData {
  static Map<int, List<Appointment>> sampleAppointments() {
    final now = DateTime.now();
    return {
      now.day: [
        const Appointment(
          id: 1,
          patientName: "Sarah Johnson",
          time: "09:00 AM",
          type: "Check-up",
          color: Colors.green,
          imageUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
          isNew: true,
        ),
        const Appointment(
          id: 2,
          patientName: "Michael Brown",
          time: "11:30 AM",
          type: "Consultation",
          color: Colors.blue,
          imageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
        ),
      ],
      now.day + 1: [
        const Appointment(
          id: 3,
          patientName: "Emily Davis",
          time: "10:15 AM",
          type: "Follow-up",
          color: Colors.orange,
          imageUrl: 'https://randomuser.me/api/portraits/women/67.jpg',
        ),
      ],
      now.day + 2: [
        const Appointment(
          id: 4,
          patientName: "David Wilson",
          time: "09:30 AM",
          type: "Surgery",
          color: AppTheme.dangerRed,
          imageUrl: 'https://randomuser.me/api/portraits/men/91.jpg',
          isNew: true,
        ),
        const Appointment(
          id: 5,
          patientName: "Jennifer Martinez",
          time: "02:00 PM",
          type: "Check-up",
          color: Colors.green,
          imageUrl: 'https://randomuser.me/api/portraits/women/10.jpg',
        ),
      ],
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const DoctorDashboard(),
    );
  }
}

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> with TickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  final List<String> _weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  late Map<int, List<Appointment>> _appointments;
  bool _isFabVisible = true;

  // Animation controllers
  late AnimationController _fabAnimationController;
  late AnimationController _profileCardController;
  late AnimationController _scheduleCardController;
  late AnimationController _calendarController;
  late AnimationController _appointmentsController;

  // Animations
  late Animation<double> _fabAnimation;
  late Animation<double> _profileCardAnimation;
  late Animation<Offset> _profileCardSlideAnimation;
  late Animation<double> _scheduleCardAnimation;
  late Animation<Offset> _scheduleCardSlideAnimation;
  late Animation<double> _calendarAnimation;
  late Animation<double> _appointmentsAnimation;

  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _appointments = AppointmentData.sampleAppointments();

    // Initialize animation controllers
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _profileCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scheduleCardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _calendarController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _appointmentsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Set up animations
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    );

    _profileCardAnimation = CurvedAnimation(
      parent: _profileCardController,
      curve: Curves.easeOutQuart,
    );

    _profileCardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _profileCardController,
      curve: Curves.easeOutCubic,
    ));

    _scheduleCardAnimation = CurvedAnimation(
      parent: _scheduleCardController,
      curve: Curves.easeOutQuart,
    );

    _scheduleCardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _scheduleCardController,
      curve: Curves.easeOutCubic,
    ));

    _calendarAnimation = CurvedAnimation(
      parent: _calendarController,
      curve: Curves.easeOutQuart,
    );

    _appointmentsAnimation = CurvedAnimation(
      parent: _appointmentsController,
      curve: Curves.easeOutQuart,
    );

    // Start animations in sequence
    Future.delayed(const Duration(milliseconds: 100), () {
      _fabAnimationController.forward();
      _profileCardController.forward();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _scheduleCardController.forward();
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _calendarController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _appointmentsController.forward();
    });
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _profileCardController.dispose();
    _scheduleCardController.dispose();
    _calendarController.dispose();
    _appointmentsController.dispose();
    super.dispose();
  }

  String _formatMonthYear(DateTime date) => DateFormat.yMMMM().format(date);
  String _formatMonthDay(DateTime date) => DateFormat.MMMd().format(date);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFloatingActionButton() {
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: _isFabVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Transform.scale(
            scale: _fabAnimation.value,
            child: FloatingActionButton.extended(
              backgroundColor: AppTheme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "New Appointment",
                style: TextStyle(color: Colors.white),
              ),
              elevation: 4,
              onPressed: () {
                _showFloatingActionButtonAnimation();
              },
            ),
          ),
        );
      },
    );
  }

  void _showFloatingActionButtonAnimation() {
    _fabAnimationController.reset();
    _fabAnimationController.forward();
  }

  Widget _buildBody() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels > 100 && _isFabVisible) {
          setState(() => _isFabVisible = false);
        } else if (scrollInfo.metrics.pixels <= 100 && !_isFabVisible) {
          setState(() => _isFabVisible = true);
          _showFloatingActionButtonAnimation();
        }
        return true;
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildDoctorProfileCard(),
                const SizedBox(height: 24),
                _buildTodayScheduleSection(),
                const SizedBox(height: 24),
                _buildPatientRequestCard(),
                const SizedBox(height: 24),
                _buildAppointmentsSection(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      pinned: true,
      stretch: true,
      backgroundColor: AppTheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: const Text(
                    'Doctor Dashboard',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'header-background',
              child: Image.network(
                'https://img.freepik.com/free-photo/doctor-reviewing-tablet_1134-206.jpg?t=st=1741845893~exp=1741849493~hmac=7d0de5c14d53647fb8630fadf94ce9d10fd0204d5eae2a8e8a1f25fe8b3cdc4b&w=1380',
                fit: BoxFit.cover,
              ),
            ),
            // Frosted glass effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.primary.withOpacity(0.6),
                      AppTheme.primary.withOpacity(0.9),
                    ],
                  ),
                ),
              ),
            ),
            // Welcome text
            Positioned(
              bottom: 48,
              left: 16,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back, Dr. John!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _formatMonthDay(_selectedDate),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
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
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Settings',
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDoctorProfileCard() {
    return FadeTransition(
      opacity: _profileCardAnimation,
      child: SlideTransition(
        position: _profileCardSlideAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [AppTheme.cardShadow],
          ),
          child: Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Hero(
                      tag: 'doctor-profile',
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/36.jpg'),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Dr. John Doe',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.verified, size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(fontSize: 10, color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Cardiologist Specialist',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildRatingStars(4.8),
                        const SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' (124 reviews)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _buildProfileActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return const Icon(Icons.star, size: 14, color: Colors.amber);
        } else if (index < rating.ceil() && rating.truncateToDouble() != rating) {
          return const Icon(Icons.star_half, size: 14, color: Colors.amber);
        } else {
          return Icon(Icons.star_border, size: 14, color: Colors.white.withOpacity(0.7));
        }
      }),
    );
  }

  Widget _buildProfileActions() {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.message_outlined,
          onTap: () {},
          tooltip: 'Messages',
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.phone_outlined,
          onTap: () {},
          tooltip: 'Call',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Icon(icon, size: 20, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodayScheduleSection() {
    return FadeTransition(
      opacity: _scheduleCardAnimation,
      child: SlideTransition(
        position: _scheduleCardSlideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Schedule",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                _buildPulsingDot(),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _buildScheduleCard(
                      icon: Icons.assignment_ind,
                      title: "Assigned Patients",
                      count: 12,
                      color: AppTheme.primary,
                      onTap: () {},
                    )
                ),
                const SizedBox(width: 12),
                Expanded(
                    child: _buildScheduleCard(
                      icon: Icons.people,
                      title: "Walk-In Patients",
                      count: 5,
                      color: AppTheme.accent,
                      onTap: () {},
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingDot() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: (1 - value).clamp(0.0, 0.7),
              child: Container(
                width: 12 + (value * 10),
                height: 12 + (value * 10),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      },
      onEnd: () => setState(() {}), // Restart animation
    );
  }

  Widget _buildScheduleCard({
    required IconData icon,
    required String title,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            elevation: 4,
            shadowColor: color.withOpacity(0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 30, color: color),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPatientRequestCard() {
    return FadeTransition(
      opacity: _scheduleCardAnimation,
      child: SlideTransition(
        position: _scheduleCardSlideAnimation,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.95, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                shadowColor: AppTheme.warningYellow.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.warningYellow.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.medical_services_outlined,
                          color: AppTheme.warningYellow,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12), // Reduced width
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 8,
                              children: [
                                const Text(
                                  "Patient Requests",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.dangerRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "3 New",
                                    style: TextStyle(
                                      color: AppTheme.dangerRed,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Review and respond to patient requests",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Reduced padding
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Review"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeTransition(
          opacity: _calendarAnimation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Upcoming Appointments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_month, size: 16),
                label: const Text("See All"),
                style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FadeTransition(
          opacity: _calendarAnimation,
          child: _buildCalendarHeader(),
        ),
        const SizedBox(height: 8),
        FadeTransition(
          opacity: _calendarAnimation,
          child: _buildCalendarDays(),),
        const SizedBox(height: 24),
        FadeTransition(
          opacity: _appointmentsAnimation,
          child: _buildAppointmentsList(),
        ),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppTheme.primary),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.subtract(const Duration(days: 7));
            });
          },
        ),
        Text(
          _formatMonthYear(_selectedDate),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppTheme.primary),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.add(const Duration(days: 7));
            });
          },
        ),
      ],
    );
  }

  Widget _buildCalendarDays() {
    final DateTime firstDay = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index) {
          final day = firstDay.add(Duration(days: index));
          final isToday = day.day == DateTime.now().day &&
              day.month == DateTime.now().month &&
              day.year == DateTime.now().year;
          final isSelected = day.day == _selectedDate.day &&
              day.month == _selectedDate.month &&
              day.year == _selectedDate.year;
          final hasAppointments = _appointments[day.day]?.isNotEmpty ?? false;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.9, end: 1.0),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: isSelected ? 1.0 : scale,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = day;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary
                            : isToday
                            ? AppTheme.primary.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isSelected
                            ? [AppTheme.softShadow]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weekDays[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            day.day.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (hasAppointments)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.accent,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentsList() {
    final todayAppointments = _appointments[_selectedDate.day] ?? [];

    if (todayAppointments.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(
              Icons.event_available,
              size: 60,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No appointments for ${DateFormat.MMMd().format(_selectedDate)}",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: todayAppointments.length,
      itemBuilder: (context, index) {
        final appointment = todayAppointments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.95, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: _buildAppointmentCard(appointment),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      // ...existing code...
      child: InkWell(
        // ...existing code...
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Patient avatar
              Hero(
                tag: 'patient-${appointment.id}',
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: appointment.isNew ? AppTheme.accent : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(appointment.imageUrl),
                  ),
                ),
              ),
              const SizedBox(width: 12), // Reduced width
              // Patient info - wrap in Flexible
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and "New" tag
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            appointment.patientName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (appointment.isNew) const SizedBox(width: 4),
                        if (appointment.isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "New",
                              style: TextStyle(
                                color: AppTheme.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Type and time - wrap in a Wrap instead of Row
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: appointment.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            appointment.type,
                            style: TextStyle(
                              fontSize: 12,
                              color: appointment.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              appointment.time,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildAppointmentActionButton(
                    color: AppTheme.primary,
                    icon: Icons.videocam_outlined,
                    onTap: () {},
                  ),
                  const SizedBox(width: 4), // Reduced width
                  _buildAppointmentActionButton(
                    color: Colors.grey.shade700,
                    icon: Icons.more_vert,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentActionButton({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Patients',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'Appointments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}