import 'package:flutter/material.dart';

/// Password Recovery ("Forgot Password?") screen for MC_SS Smart Scheduler.
///
/// Matches the reference design: back button, logo header, "Forgot Password?"
/// title + subtitle, email field with validation, primary "Send Reset Link"
/// button, an "OR" divider, and a bottom info card linking back to Sign In.
class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isSubmitting = false;

  // ---------------------------------------------------------------------
  // Color palette (mirrors the app's navy/blue neumorphic-lite scheme).
  // TODO: Replace with context.appColors once this screen is wired into
  // the shared AppColorsExt ThemeExtension used across the rest of the app.
  // ---------------------------------------------------------------------
  static const Color _navyDark = Color(0xFF0B1E3D);
  static const Color _primaryBlue = Color(0xFF2F6BFF);
  static const Color _mutedGray = Color(0xFF7A8AA0);
  static const Color _fieldBorder = Color(0xFFE1E5EC);
  static const Color _scaffoldBg = Color(0xFFF7F8FA);
  static const Color _cardBg = Color(0xFFEEF3FC);
  static const Color _cardBorder = Color(0xFFD9E3F5);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Please enter your email address';
    }
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _handleSendResetLink() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);

    // TODO: Integrate real password-reset logic here, e.g.:
    // await AuthService.sendPasswordResetEmail(_emailController.text.trim());
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reset link sent to ${_emailController.text.trim()}'),
        backgroundColor: _primaryBlue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleBackToSignIn() {
    // Return to the previous screen (Login) without rebuilding it.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildBackButton(),
                const SizedBox(height: 16),
                _buildLogoHeader(),
                const SizedBox(height: 28),
                _buildTitleAndSubtitle(),
                const SizedBox(height: 28),
                _buildEmailField(),
                const SizedBox(height: 24),
                _buildSendResetButton(),
                const SizedBox(height: 28),
                _buildOrDivider(),
                const SizedBox(height: 24),
                _buildBackToSignInCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Sections
  // ---------------------------------------------------------------------

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: _handleBackToSignIn,
        icon: const Icon(Icons.arrow_back, color: _navyDark, size: 26),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
        splashRadius: 22,
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // TODO: Ensure this asset is registered in pubspec.yaml:
        //   assets:
        //     - assets/image/register01.png
        Image.asset(
          'assets/image/register01.png',
          height: 48,
          width: 48,
          errorBuilder: (context, error, stackTrace) {
            // Graceful fallback if the asset isn't registered/found yet.
            return Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: _primaryBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.event_note, color: _primaryBlue),
            );
          },
        ),
        const SizedBox(width: 10),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              color: _navyDark,
            ),
            children: [
              const TextSpan(text: 'MC'),
              TextSpan(
                text: '_SS',
                style: TextStyle(color: _primaryBlue),
              ),
              const TextSpan(text: '\n'),
              const TextSpan(
                text: 'Smart Scheduler',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  color: _mutedGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: _navyDark,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "No worries! Enter your email address and we'll send you a link to reset your password.",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: _mutedGray,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email Address',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _navyDark,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: _validateEmail,
          style: const TextStyle(
            fontSize: 15,
            color: _navyDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your email',
            hintStyle: const TextStyle(
              color: _mutedGray,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: const Icon(
              Icons.mail_outline,
              color: _mutedGray,
              size: 20,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 4,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _fieldBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _fieldBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _primaryBlue, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSendResetButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSendResetLink,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          disabledBackgroundColor: _primaryBlue.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail_outline, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Send Reset Link',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: _fieldBorder, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _mutedGray,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: _fieldBorder, thickness: 1)),
      ],
    );
  }

  Widget _buildBackToSignInCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _primaryBlue, width: 1.4),
                ),
                child: const Icon(
                  Icons.lock_outline,
                  color: _primaryBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Remember your password?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _navyDark,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Back to sign in to access your account.',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: _mutedGray,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: _handleBackToSignIn,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Back to Sign In',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _primaryBlue,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: _primaryBlue, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
