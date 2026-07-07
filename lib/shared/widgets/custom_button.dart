import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Visual style of a [CustomButton].
enum CustomButtonVariant {
  /// Primary Blue → Secondary Cyan gradient fill (e.g. main FAB / CTA).
  filled,

  /// Solid single-color fill, no gradient (e.g. secondary confirm actions).
  solid,

  /// Bordered, transparent background (e.g. the "Schedule" pill button).
  outlined,

  /// No border or fill, just tinted text (e.g. "View All", "Customize").
  text,
}

enum CustomButtonSize { small, medium, large }

/// A flexible, themeable button matching the MC_SS Smart Scheduler
/// neumorphic-lite aesthetic. Supports filled/outlined/text variants,
/// leading icons, loading spinners, and disabled states out of the box.
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = CustomButtonVariant.filled,
    this.size = CustomButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isExpanded = false,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final CustomButtonVariant variant;
  final CustomButtonSize size;

  /// Optional leading icon, shown before the label.
  final IconData? icon;

  /// Optional trailing icon, shown after the label (e.g. a chevron).
  final IconData? trailingIcon;

  /// Shows a small spinner in place of the icon/label and disables taps.
  final bool isLoading;

  /// If true, the button fills the width of its parent.
  final bool isExpanded;

  /// Overrides the variant's default color (falls back to theme primary).
  final Color? color;

  bool get _isDisabled => onPressed == null || isLoading;

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case CustomButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 8);
      case CustomButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 13);
      case CustomButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double get _fontSize {
    switch (size) {
      case CustomButtonSize.small:
        return 13;
      case CustomButtonSize.medium:
        return 15;
      case CustomButtonSize.large:
        return 16;
    }
  }

  double get _spinnerSize => size == CustomButtonSize.small ? 14 : 16;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appColors;
    final baseColor = color ?? theme.colorScheme.primary;

    Widget content = _Content(
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      fontSize: _fontSize,
      spinnerSize: _spinnerSize,
      foreground: _foregroundColor(theme, baseColor),
    );

    Widget button;
    switch (variant) {
      case CustomButtonVariant.filled:
        button = _buildFilled(theme, tokens, content);
        break;
      case CustomButtonVariant.solid:
        button = _buildSolid(theme, baseColor, content);
        break;
      case CustomButtonVariant.outlined:
        button = _buildOutlined(theme, baseColor, content);
        break;
      case CustomButtonVariant.text:
        button = _buildText(theme, baseColor, content);
        break;
    }

    return isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }

  Color _foregroundColor(ThemeData theme, Color baseColor) {
    if (_isDisabled && variant != CustomButtonVariant.text) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.4);
    }
    switch (variant) {
      case CustomButtonVariant.filled:
      case CustomButtonVariant.solid:
        return Colors.white;
      case CustomButtonVariant.outlined:
      case CustomButtonVariant.text:
        return _isDisabled
            ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
            : baseColor;
    }
  }

  Widget _buildFilled(ThemeData theme, AppColorsExt tokens, Widget content) {
    final disabled = _isDisabled;
    return Opacity(
      opacity: disabled ? 0.55 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: disabled ? null : tokens.primaryGradient,
          color: disabled
              ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: disabled
              ? null
              : [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.30),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: disabled ? null : onPressed,
            child: Padding(padding: _padding, child: content),
          ),
        ),
      ),
    );
  }

  Widget _buildSolid(ThemeData theme, Color baseColor, Widget content) {
    final disabled = _isDisabled;
    return Material(
      color: disabled
          ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
          : baseColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: disabled ? null : onPressed,
        child: Padding(padding: _padding, child: content),
      ),
    );
  }

  Widget _buildOutlined(ThemeData theme, Color baseColor, Widget content) {
    final disabled = _isDisabled;
    final borderColor = disabled
        ? theme.colorScheme.onSurface.withValues(alpha: 0.2)
        : baseColor;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: disabled ? null : onPressed,
        child: Container(
          padding: _padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor, width: 1.4),
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildText(ThemeData theme, Color baseColor, Widget content) {
    final disabled = _isDisabled;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: disabled ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: content,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.label,
    required this.icon,
    required this.trailingIcon,
    required this.isLoading,
    required this.fontSize,
    required this.spinnerSize,
    required this.foreground,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final double fontSize;
  final double spinnerSize;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: spinnerSize,
            height: spinnerSize,
            child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    final children = <Widget>[];
    if (icon != null) {
      children.add(Icon(icon, size: fontSize + 3, color: foreground));
      children.add(const SizedBox(width: 8));
    }
    children.add(
      Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    if (trailingIcon != null) {
      children.add(const SizedBox(width: 6));
      children.add(Icon(trailingIcon, size: fontSize + 3, color: foreground));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
