import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A clean, modern input field matching the MC_SS Smart Scheduler
/// aesthetic: soft rounded fills that darken subtly on focus, with
/// support for prefix/suffix icons, hint text, validation, and a
/// built-in password visibility toggle.
class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autofocus = false,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;

  /// If true, shows a password field with a built-in eye toggle
  /// (unless [suffixIcon] is explicitly provided).
  final bool obscureText;

  final bool enabled;
  final bool readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final bool autofocus;
  final FocusNode? focusNode;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _obscured = true;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _hasFocus = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tokens = context.appColors;
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    final fillColor = !widget.enabled
        ? tokens.secondaryBackground.withValues(alpha: 0.5)
        : _hasFocus
            ? tokens.secondaryBackground
            : tokens.secondaryBackground.withValues(alpha: 0.7);

    final borderColor = hasError
        ? tokens.error
        : _hasFocus
            ? theme.colorScheme.primary
            : Colors.transparent;

    Widget? suffix;
    if (widget.suffixIcon != null) {
      suffix = IconButton(
        icon: Icon(widget.suffixIcon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        onPressed: widget.onSuffixIconTap,
      );
    } else if (widget.obscureText) {
      suffix = IconButton(
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 8),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.4),
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText && _obscured,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            autofocus: widget.autofocus,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            validator: widget.validator,
            style: theme.textTheme.bodyLarge,
            cursorColor: theme.colorScheme.primary,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, size: 20, color: theme.colorScheme.onSurfaceVariant)
                  : null,
              suffixIcon: suffix,
              filled: false,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorStyle: const TextStyle(height: 0, fontSize: 0),
            ),
          ),
        ),
        if (hasError || widget.helperText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              hasError ? widget.errorText! : widget.helperText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: hasError ? tokens.error : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
