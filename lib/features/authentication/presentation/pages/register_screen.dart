import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:mc_ssp/features/authentication/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Color kPrimaryBlue = Color(0xFF1656F5);
const Color kMutedText = Color(0xFF6B7280);
const Color kFieldBorder = Color(0xFFE2E6EE);

enum _PasswordStrength { empty, weak, medium, strong }

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = true;
  bool _isLoading = false;
  _PasswordStrength _passwordStrength = _PasswordStrength.empty;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updatePasswordStrength);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final value = _passwordController.text;
    _PasswordStrength strength;

    if (value.isEmpty) {
      strength = _PasswordStrength.empty;
    } else if (value.length < 6) {
      strength = _PasswordStrength.weak;
    } else if (value.length < 10 ||
        !RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value)) {
      strength = _PasswordStrength.medium;
    } else {
      strength = _PasswordStrength.strong;
    }

    if (strength != _passwordStrength) {
      setState(() => _passwordStrength = strength);
    }
  }

  void _handleCreateAccount() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms of Service and Privacy Policy',
          ),
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      _authService
          .registerAndSendVerification(
            name: name,
            email: email,
            password: password,
          )
          .then((_) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Account created successfully. You can sign in now.',
                ),
              ),
            );
            Navigator.of(context).pop();
          })
          .catchError((err) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            final message = (err is FirebaseAuthException)
                ? AuthService.getUserFacingErrorMessage(err)
                : 'Registration failed';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          });
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF4FF), Color(0xFFF7F9FF), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  _buildBackButton(),
                  const SizedBox(height: 12),
                  _buildLogoSection(),
                  const SizedBox(height: 20),
                  const Text(
                    'Create your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Join MC_SS and organize your day smarter',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: kMutedText),
                  ),
                  const SizedBox(height: 24),
                  _buildFormCard(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black26,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _navigateToLogin,
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: Icon(Icons.arrow_back, size: 20, color: Color(0xFF101828)),
          ),
        ),
      ),
    );
  }

  /// Logo placeholder. Replace `assets/logo.png` with your actual asset
  /// and register it under `flutter: assets:` in pubspec.yaml.
  Widget _buildLogoSection() {
    return Center(
      child: Image.asset(
        'assets/images/register01.png',
        height: 280,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.calendar_month,
              size: 40,
              color: kPrimaryBlue,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabeledField(
            label: 'Full Name',
            controller: _nameController,
            hintText: 'Enter your full name',
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          _buildLabeledField(
            label: 'Email',
            controller: _emailController,
            hintText: 'Enter your email',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          _buildLabeledField(
            label: 'Password',
            controller: _passwordController,
            hintText: 'Create a password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: kMutedText,
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please create a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          _buildPasswordStrengthIndicator(),
          const SizedBox(height: 18),
          _buildLabeledField(
            label: 'Confirm Password',
            controller: _confirmPasswordController,
            hintText: 'Confirm your password',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: kMutedText,
                size: 20,
              ),
              onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          _buildTermsCheckbox(),
          const SizedBox(height: 20),
          _buildPrimaryButton(
            label: 'Create Account',
            isLoading: _isLoading,
            onPressed: _handleCreateAccount,
          ),
          const SizedBox(height: 20),
          const Divider(color: kFieldBorder, thickness: 1),
          const SizedBox(height: 16),
          Center(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, color: Color(0xFF101828)),
                children: [
                  const TextSpan(text: 'Already have an account? '),
                  TextSpan(
                    text: 'Log in',
                    style: const TextStyle(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _navigateToLogin,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF101828),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: kMutedText, fontSize: 14),
            prefixIcon: Icon(prefixIcon, color: kMutedText, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kFieldBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kFieldBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kPrimaryBlue, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final int filledSegments;
    final Color activeColor;
    final String label;

    switch (_passwordStrength) {
      case _PasswordStrength.empty:
        filledSegments = 0;
        activeColor = kFieldBorder;
        label = '';
        break;
      case _PasswordStrength.weak:
        filledSegments = 1;
        activeColor = Colors.redAccent;
        label = 'Weak';
        break;
      case _PasswordStrength.medium:
        filledSegments = 2;
        activeColor = Colors.orange;
        label = 'Medium';
        break;
      case _PasswordStrength.strong:
        filledSegments = 3;
        activeColor = Colors.green;
        label = 'Strong';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(3, (index) {
            final bool isFilled = index < filledSegments;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index != 2 ? 6 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: isFilled ? activeColor : kFieldBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 12, color: kMutedText),
              children: [
                const TextSpan(text: 'Password strength: '),
                TextSpan(
                  text: label,
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: _agreedToTerms,
            activeColor: kPrimaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (value) =>
                setState(() => _agreedToTerms = value ?? false),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF101828),
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: Navigate to Terms of Service page.
                      },
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: kPrimaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // TODO: Navigate to Privacy Policy page.
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
