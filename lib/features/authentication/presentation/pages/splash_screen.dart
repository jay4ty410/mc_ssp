import 'dart:math';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController logoController;
  late AnimationController rotateController;
  late AnimationController waveController;

  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeOutBack),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: logoController, curve: Curves.easeIn));

    logoController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    logoController.dispose();
    rotateController.dispose();
    waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: waveController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xffF8FAFD), Color(0xffE9EEF6)],
              ),
            ),
            child: Stack(
              children: [
                /// Decorative Top Shape
                Positioned(
                  top: -150,
                  right: -100,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                /// Waves
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: size.height * .35,
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: Size(size.width, 350),
                          painter: WavePainter(
                            const Color(0xffDDEEFF),
                            waveController.value,
                            0,
                          ),
                        ),
                        CustomPaint(
                          size: Size(size.width, 350),
                          painter: WavePainter(
                            const Color(0xff99CCFF),
                            waveController.value,
                            20,
                          ),
                        ),
                        CustomPaint(
                          size: Size(size.width, 350),
                          painter: WavePainter(
                            const Color(0xff4AA3FF),
                            waveController.value,
                            40,
                          ),
                        ),
                        CustomPaint(
                          size: Size(size.width, 350),
                          painter: WavePainter(
                            const Color(0xff006DFF),
                            waveController.value,
                            60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Floating Icons
                Positioned(
                  left: 40,
                  bottom: 170,
                  child: glassIcon(Icons.calendar_month_outlined),
                ),

                Positioned(
                  left: 160,
                  bottom: 120,
                  child: glassIcon(Icons.task_alt_outlined),
                ),

                Positioned(
                  right: 160,
                  bottom: 100,
                  child: glassIcon(Icons.access_time),
                ),

                Positioned(
                  right: 40,
                  bottom: 170,
                  child: glassIcon(Icons.notifications_none),
                ),

                /// Main Content
                SafeArea(
                  child: Center(
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: rotateController,
                              builder: (context, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Transform.rotate(
                                      angle: rotateController.value * pi * 2,
                                      child: Container(
                                        width: 220,
                                        height: 220,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.lightBlue,
                                            width: 5,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),

                                    Image.asset(
                                      "assets/images/mcss_logo.png",
                                      width: 180,
                                    ),
                                  ],
                                );
                              },
                            ),

                            const SizedBox(height: 15),

                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "MC_",
                                    style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xff001F5B),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "SS",
                                    style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xff12B2FF),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text(
                              "Smart Scheduler",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),

                            const SizedBox(height: 30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 65,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                dot(true),
                                const SizedBox(width: 8),
                                dot(false),
                                const SizedBox(width: 8),
                                dot(false),
                              ],
                            ),

                            const SizedBox(height: 45),

                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Plan ",
                                    style: TextStyle(color: Color(0xff102A5C)),
                                  ),
                                  TextSpan(
                                    text: "smarter",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ". Stay on track.",
                                    style: TextStyle(color: Color(0xff102A5C)),
                                  ),
                                ],
                              ),
                              style: TextStyle(fontSize: 22),
                            ),

                            const SizedBox(height: 8),

                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Achieve ",
                                    style: TextStyle(color: Color(0xff102A5C)),
                                  ),
                                  TextSpan(
                                    text: "more.",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget dot(bool active) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.blue : Colors.grey.withValues(alpha: .35),
      ),
    );
  }

  Widget glassIcon(IconData icon) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: .15),
        border: Border.all(color: Colors.white.withValues(alpha: .2)),
      ),
      child: Icon(icon, size: 34, color: Colors.white70),
    );
  }
}

class WavePainter extends CustomPainter {
  final Color color;
  final double animationValue;
  final double offset;

  WavePainter(this.color, this.animationValue, this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();

    path.moveTo(0, size.height * .45);

    path.quadraticBezierTo(
      size.width * .25,
      size.height * (.30 + animationValue * .05),
      size.width * .50,
      size.height * (.45 + animationValue * .05),
    );

    path.quadraticBezierTo(
      size.width * .75,
      size.height * (.60 + animationValue * .05),
      size.width,
      size.height * (.40 + animationValue * .05),
    );

    path.lineTo(size.width, size.height + offset);
    path.lineTo(0, size.height + offset);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return true;
  }
}
