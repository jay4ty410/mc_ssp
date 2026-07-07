import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Sizing presets for [LoadingWidget]'s inline variant.
enum LoadingSize { small, medium, large }

/// A polished loading indicator matching MC_SS Smart Scheduler's theme:
/// a circular ring painted with the Primary Blue → Secondary Cyan gradient.
///
/// Use [LoadingWidget.fullScreen] to cover an entire page (with a scrim and
/// optional message), or the default constructor for an inline/local token
/// (e.g. inside a button row, list footer, or refresh indicator).
class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key, this.size = LoadingSize.medium, this.message})
    : _fullScreen = false;

  const LoadingWidget.fullScreen({super.key, this.message})
    : size = LoadingSize.large,
      _fullScreen = true;

  final LoadingSize size;
  final String? message;
  final bool _fullScreen;

  double get _diameter {
    switch (size) {
      case LoadingSize.small:
        return 20;
      case LoadingSize.medium:
        return 32;
      case LoadingSize.large:
        return 48;
    }
  }

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final theme = Theme.of(context);

    final ring = SizedBox(
      width: widget._diameter,
      height: widget._diameter,
      child: RotationTransition(
        turns: _controller,
        child: CustomPaint(
          painter: _GradientRingPainter(
            gradient: tokens.primaryGradient,
            strokeWidth: widget._diameter <= 20 ? 2.4 : 3.4,
          ),
        ),
      ),
    );

    if (!widget._fullScreen) {
      if (widget.message == null) return ring;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ring,
          const SizedBox(width: 12),
          Text(widget.message!, style: theme.textTheme.bodyMedium),
        ],
      );
    }

    return Container(
      color: theme.scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ring,
          if (widget.message != null) ...[
            const SizedBox(height: 20),
            Text(
              widget.message!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  _GradientRingPainter({required this.gradient, required this.strokeWidth});

  final Gradient gradient;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw ~75% of a circle so the gradient rotation reads as motion.
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.55,
      4.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) =>
      oldDelegate.gradient != gradient ||
      oldDelegate.strokeWidth != strokeWidth;
}

/// A thin shimmering placeholder box for skeleton-loading card content
/// (e.g. while schedule rows are being fetched). Pairs well with
/// [CustomCard] to mimic the card layout while data loads.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height = 14,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.appColors;
    final base = tokens.secondaryBackground;
    final highlight = tokens.secondaryBackground.withValues(alpha: 0.4);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment(-1 + _controller.value * 3, 0),
                end: Alignment(0 + _controller.value * 3, 0),
                colors: [base, highlight, base],
              ).createShader(rect);
            },
            child: Container(
              width: widget.width,
              height: widget.height,
              color: base,
            ),
          ),
        );
      },
    );
  }
}
