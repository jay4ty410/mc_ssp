import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _waveController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _waveOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _waveOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.easeIn));

    _logoController.forward().then((_) {
      _textController.forward();
      _waveController.forward();
    });

    // Navigate to login after 3 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const LoginScreen(),
            transitionsBuilder: (_, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEEF4FB), Color(0xFFDDECF8), Color(0xFFCDE3F5)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Wave background (bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _waveOpacity,
                child: const _WaveBackground(),
              ),
            ),

            // Floating icons over waves
            FadeTransition(
              opacity: _waveOpacity,
              child: const _FloatingIcons(),
            ),

            // Main centred content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Animated logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: child,
                      ),
                    ),
                    child: const _LogoWidget(),
                  ),

                  const SizedBox(height: 32),

                  // Brand name
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: const _BrandText(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Pagination dots
                  FadeTransition(
                    opacity: _textOpacity,
                    child: const _PaginationDots(),
                  ),

                  const SizedBox(height: 36),

                  // Tagline
                  FadeTransition(
                    opacity: _textOpacity,
                    child: const _TaglineText(),
                  ),

                  const Spacer(flex: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Logo ────────────────────────────────────────────────────────────────────

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbit ring
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(1.1),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF29B6F6), width: 3.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF29B6F6).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Clock (behind calendar)
          Positioned(
            right: 18,
            top: 28,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: CustomPaint(painter: _ClockPainter()),
              ),
            ),
          ),

          // Calendar card (front)
          Positioned(
            left: 12,
            top: 38,
            child: Container(
              width: 115,
              height: 130,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A237E), Color(0xFF1E88E5)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1565C0).withValues(alpha: 0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const _CalendarCard(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Clock Painter ───────────────────────────────────────────────────────────

class _ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy);

    final darkPaint = Paint()
      ..color = const Color(0xFF1A237E)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Tick marks
    for (int i = 0; i < 12; i++) {
      final angle = (i * math.pi * 2 / 12) - math.pi / 2;
      final outerR = r * 0.90;
      final innerR = i % 3 == 0 ? r * 0.72 : r * 0.80;
      canvas.drawLine(
        Offset(cx + innerR * math.cos(angle), cy + innerR * math.sin(angle)),
        Offset(cx + outerR * math.cos(angle), cy + outerR * math.sin(angle)),
        darkPaint..strokeWidth = i % 3 == 0 ? 2.5 : 1.5,
      );
    }

    // Hour hand — pointing ~10 o'clock direction
    final hourAngle = -2.1;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(
        cx + r * 0.48 * math.cos(hourAngle),
        cy + r * 0.48 * math.sin(hourAngle),
      ),
      darkPaint..strokeWidth = 3.5,
    );

    // Minute hand — pointing ~2 o'clock direction
    final minAngle = 0.72;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(
        cx + r * 0.64 * math.cos(minAngle),
        cy + r * 0.64 * math.sin(minAngle),
      ),
      darkPaint..strokeWidth = 2.5,
    );

    // Center dot
    canvas.drawCircle(
      Offset(cx, cy),
      4,
      Paint()..color = const Color(0xFF1A237E),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Calendar Card ───────────────────────────────────────────────────────────

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
      child: Column(
        children: [
          // Binding rings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              5,
              (_) => Container(
                width: 8,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFF90CAF9),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Grid rows
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_gridRow(hasCheck: false), _gridRow(hasCheck: true)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridRow({required bool hasCheck}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(3, (i) {
        final isCheck = hasCheck && i == 2;
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: isCheck
                ? const Color(0xFF42A5F5)
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: isCheck
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : null,
        );
      }),
    );
  }
}

// ─── Brand Text ──────────────────────────────────────────────────────────────

class _BrandText extends StatelessWidget {
  const _BrandText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'MC_',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF0D1B4B),
                  letterSpacing: 1,
                ),
              ),
              TextSpan(
                text: 'SS',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF1565C0),
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Smart Scheduler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ─── Pagination Dots ─────────────────────────────────────────────────────────

class _PaginationDots extends StatelessWidget {
  const _PaginationDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Active line
        Container(
          width: 30,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        // Active dot
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            color: Color(0xFF1565C0),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        // Inactive dot
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: const Color(0xFF90CAF9).withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

// ─── Tagline ─────────────────────────────────────────────────────────────────

class _TaglineText extends StatelessWidget {
  const _TaglineText();

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF0D1B4B),
      fontWeight: FontWeight.w500,
    );
    const accentStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF1565C0),
      fontWeight: FontWeight.w700,
    );

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: 'Plan '),
              TextSpan(text: 'smarter', style: accentStyle),
              TextSpan(text: '. Stay on track.'),
            ],
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: baseStyle,
            children: [
              TextSpan(text: 'Achieve '),
              TextSpan(text: 'more', style: accentStyle),
              TextSpan(text: '.'),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Wave Background ─────────────────────────────────────────────────────────

class _WaveBackground extends StatelessWidget {
  const _WaveBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: CustomPaint(painter: _WavePainter()),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    void wave(Paint paint, double y1, double cy1, double y2, double cy2) {
      final path = Path()
        ..moveTo(0, size.height * y1)
        ..cubicTo(
          size.width * 0.28,
          size.height * cy1,
          size.width * 0.62,
          size.height * cy2,
          size.width,
          size.height * y2,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }

    wave(
      Paint()
        ..color = const Color(0xFF64B5F6).withValues(alpha: 0.45)
        ..style = PaintingStyle.fill,
      0.50,
      0.32,
      0.42,
      0.62,
    );

    wave(
      Paint()
        ..color = const Color(0xFF1E88E5).withValues(alpha: 0.72)
        ..style = PaintingStyle.fill,
      0.62,
      0.45,
      0.52,
      0.70,
    );

    wave(
      Paint()
        ..color = const Color(0xFF1565C0)
        ..style = PaintingStyle.fill,
      0.78,
      0.58,
      0.70,
      0.82,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── Floating Icons ───────────────────────────────────────────────────────────

class _FloatingIcons extends StatelessWidget {
  const _FloatingIcons();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Positioned(
          bottom: h * 0.19,
          left: 24,
          child: const _GlassIcon(icon: Icons.calendar_month_outlined),
        ),
        Positioned(
          bottom: h * 0.12,
          left: 88,
          child: const _GlassIcon(icon: Icons.check_box_outlined),
        ),
        Positioned(
          bottom: h * 0.10,
          right: 108,
          child: const _GlassIcon(icon: Icons.access_time_outlined),
        ),
        Positioned(
          bottom: h * 0.17,
          right: 24,
          child: const _GlassIcon(icon: Icons.notifications_outlined),
        ),
      ],
    );
  }
}

class _GlassIcon extends StatelessWidget {
  final IconData icon;
  const _GlassIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 1),
      ),
      child: Icon(
        icon,
        size: 28,
        color: const Color(0xFF1565C0).withValues(alpha: 0.82),
      ),
    );
  }
}
