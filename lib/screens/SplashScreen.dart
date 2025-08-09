import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myprojectshop/controller/auth_controller.dart';
import 'package:myprojectshop/screens/Onboardscreen.dart';
import 'package:myprojectshop/screens/home_screen.dart';
import 'package:myprojectshop/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  double _loadingProgress = 0.0;
  Timer? _progressTimer;

  void checkLoginStatusAfterLoading() async {
    final authController = Get.find<AuthController>();
    await authController.loadUser();

    // تأخير حتى تصل نسبة التحميل إلى 100%
    while (_loadingProgress < 1.0) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    // الآن ننتقل بعد التحميل الكامل
    if (!mounted) return;

    if (authController.isLoggedIn.value) {
      Get.offAll(() => HomeScreen());
    } else {
      Get.offAll(() => Onboardscreen());
    }
  }

  @override
  void initState() {
    super.initState();

    checkLoginStatusAfterLoading();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // // Start the loading progress
    _startLoadingProgress();

    // Timer(const Duration(seconds: 3), () {
    //   if (mounted) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => Onboardscreen()),
    //     );
    //   }
    // });
  }

  void _startLoadingProgress() {
    const totalstap = 100; // Total steps for the loading progress
    const stepDuration = Duration(milliseconds: 30); // Duration for each step
    _progressTimer = Timer.periodic(stepDuration, (timer) {
      setState(() {
        if (_loadingProgress < 1.0) {
          _loadingProgress += 1 / totalstap;
          // Increase the progress
          // _loadingProgress = 1.0; // Cap the progress at 1.0
          // timer.cancel(); // Stop the timer when progress is complete
        } else {
          _progressTimer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppTheme.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(
                    255,
                    209,
                    215,
                    198,
                  ).withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                size: 64,
                                color: const Color.fromARGB(255, 55, 41, 214),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "ShopEase",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Your Premium Shopping Experience",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                            // You can add another Text widget here if needed, or remove this line if not required
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 48),

                  SizedBox(
                    width: 200,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _loadingProgress,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 6,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '${(_loadingProgress * 100).toInt()}%',
                          style: TextStyle(color: Colors.white, fontSize: 14),
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
    );
  }
}
