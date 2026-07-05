import 'package:flutter/material.dart';
import 'custom_button.dart';

/// A clean, centered placeholder for empty lists — no events, no tasks,
/// no search results, etc. Pairs an icon (or custom illustration) with a
/// title, a subtitle, and an optional call-to-action button.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.event_busy_rounded,
    this.imagePath,
    this.actionLabel,
    this.onAction,
    this.iconSize = 56,
    this.compact = false,
  });

  /// Main heading, shown in the primary text color.
  final String title;

  /// Supporting description, shown in the secondary text color.
  final String? subtitle;

  /// Fallback icon shown inside a soft tonal circle when [imagePath] is null.
  final IconData icon;

  /// Optional illustration asset (e.g. 'assets/images/empty_calendar.png').
  /// Takes priority over [icon] when provided.
  final String? imagePath;

  final String? actionLabel;
  final VoidCallback? onAction;
  final double iconSize;

  /// Use a smaller, denser layout for inline placements (e.g. inside a
  /// [CustomCard] rather than filling the whole screen).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: compact ? 16 : 48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Image.asset(imagePath!, height: compact ? 96 : 140)
            else
              Container(
                width: (iconSize * 2).clamp(72, 120),
                height: (iconSize * 2).clamp(72, 120),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: iconSize, color: theme.colorScheme.primary),
              ),
            SizedBox(height: compact ? 16 : 24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: compact ? 20 : 28),
              CustomButton(
                label: actionLabel!,
                onPressed: onAction,
                icon: Icons.add_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
