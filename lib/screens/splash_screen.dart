import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  // For shimmer effect
  bool _isShimmering = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller with longer duration for smoother animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Define multiple animations for more visual interest
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _controller.forward();

    // Add shimmer effect after initial animation
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _isShimmering = true;
      });
    });

    // Navigate to the next screen with fade transition
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed(
        '/welcome',
        arguments: {
          'fadeIn': true,
        },
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2E6EEC), // Blue
              const Color(0xFF3A5FCC), // Mid blue
              const Color(0xFF6A11CB), // Purple
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Background particles (subtle dots)
            ..._buildParticles(40),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo with multiple effects
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Container(
                              width: size.width * 0.45,
                              height: size.width * 0.45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/img.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // App name with improved typography and effects
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return _isShimmering
                          ? const LinearGradient(
                        colors: [
                          Colors.white70,
                          Colors.white,
                          Colors.white70,
                        ],
                        stops: [0.0, 0.5, 1.0],
                        begin: Alignment(-1.0, -0.2),
                        end: Alignment(1.0, 0.2),
                        tileMode: TileMode.clamp,
                      ).createShader(bounds)
                          : const LinearGradient(
                        colors: [Colors.white, Colors.white],
                      ).createShader(bounds);
                    },
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _controller.value,
                      child: Text(
                        'IntelAI MediLocker',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.075,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          height: 1.1,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: Colors.black45,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Tagline with fade-in animation
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _controller.value > 0.7 ? 1.0 : 0.0,
                    child: Text(
                      'Secure Medical Records Management',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.06),

                  // Custom progress indicator
                  FadeTransition(
                    opacity: _opacityAnimation,
                    child: _buildCustomProgressIndicator(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Create background particles
  List<Widget> _buildParticles(int count) {
    final random = DateTime.now().millisecondsSinceEpoch;
    final List<Widget> particles = [];

    for (int i = 0; i < count; i++) {
      final left = ((random + (i * 7)) % 100) / 100 * MediaQuery.of(context).size.width;
      final top = ((random + (i * 13)) % 100) / 100 * MediaQuery.of(context).size.height;
      final size = ((random + (i * 17)) % 5) + 2.0;
      final opacity = ((random + (i * 23)) % 6) / 10 + 0.1;

      particles.add(
        Positioned(
          left: left,
          top: top,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return particles;
  }

  // Custom animated progress indicator
  Widget _buildCustomProgressIndicator() {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ring
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  strokeWidth: 3,
                ),
              ),

              // Inner pulse
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  return Container(
                    width: 30 * value,
                    height: 30 * value,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3 * (1 - value)),
                      shape: BoxShape.circle,
                    ),
                  );
                },
                onEnd: () {
                  setState(() {}); // Rebuild to restart the animation
                },
              ),

              // Center dot
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),

        // Loading text with animation
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: 3),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, child) {
            return Text(
              'Loading' + '.' * (value % 4),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            );
          },
          onEnd: () {
            setState(() {}); // Rebuild to restart the animation
          },
        ),
      ],
    );
  }
}