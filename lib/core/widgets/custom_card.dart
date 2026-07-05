import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The core surface/container used throughout MC_SS Smart Scheduler —
/// mirrors the "Today's Schedule" and "AI Suggestions" panels in the
/// reference mockup: large soft-rounded corners, a very gentle blurred
/// drop shadow in light mode, and an optional AI-tinted gradient look.
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.borderRadius = 22,
    this.isAiCard = false,
    this.onTap,
    this.backgroundColor,
    this.border,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  /// Applies the AI Card Gradient background + AI Accent border tint.
  final bool isAiCard;

  final VoidCallback? onTap;

  /// Overrides the default card background (ignored when [isAiCard] is true).
  final Color? backgroundColor;

  /// Overrides the default border (ignored when [isAiCard] is true, which
  /// always applies a subtle AI Accent tinted border).
  final BoxBorder? border;

  /// When false, disables the soft drop shadow (useful for nested cards).
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appColors;
    final radius = BorderRadius.circular(borderRadius);

    final decoration = BoxDecoration(
      gradient: isAiCard ? tokens.aiCardGradient : null,
      color: isAiCard ? null : (backgroundColor ?? theme.colorScheme.surface),
      borderRadius: radius,
      border: isAiCard
          ? Border.all(color: tokens.aiAccent.withValues(alpha: 0.18), width: 1)
          : border,
      boxShadow: elevated ? tokens.softShadow : null,
    );

    final content = Padding(padding: padding, child: child);

    if (onTap == null) {
      return Container(margin: margin, decoration: decoration, child: content);
    }

    return Container(
      margin: margin,
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(onTap: onTap, child: content),
      ),
    );
  }
}

/// A small circular "icon chip" used inside cards (e.g. the colored icon
/// bubbles next to each schedule row: work / personal / gym / etc).
class CardIconBadge extends StatelessWidget {
  const CardIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

/// A compact stat tile matching the "Today's Events / Completed / Pending /
/// Overdue" row at the top of the home screen. Meant to be laid out in a
/// [Row] with [Expanded] siblings, typically inside a [CustomCard].
class CardStatItem extends StatelessWidget {
  const CardStatItem({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.sublabel,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? sublabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CardIconBadge(icon: icon, color: iconColor, size: 40),
        const SizedBox(height: 10),
        Text(label, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.headlineSmall),
        if (sublabel != null) Text(sublabel!, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
