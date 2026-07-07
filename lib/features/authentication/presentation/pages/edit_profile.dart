import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// TODO: Adjust these import paths to match your project structure.
import 'app_theme.dart'; // Provides AppColorsExt + context.appColors
import 'app_bottom_navigation_bar.dart'; // Shared bottom nav w/ center FAB

/// Edit Profile screen.
///
/// Mirrors the neumorphic-lite card layout used across the app:
///  - Profile Photo card
///  - Personal Information card
///  - Additional Information card
///  - Danger Zone action
///  - Shared bottom navigation bar (Profile tab active -> index 3)
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal information controllers
  final _fullNameController = TextEditingController(text: 'Alex Johnson');
  final _emailController = TextEditingController(text: 'alex.johnson@mcss.com');
  final _phoneController = TextEditingController(text: '(555) 123-4567');
  final _jobTitleController = TextEditingController(text: 'Project Manager');
  final _departmentController = TextEditingController(text: 'Operations');
  final _bioController = TextEditingController(
    text:
        'Project manager with a passion for productivity and team collaboration.',
  );

  static const int _bioMaxLength = 150;

  // Additional information dropdown values
  String _selectedTimezone = '(GMT-05:00) Eastern Time (US & Canada)';
  String _selectedLanguage = 'English';
  String _selectedDateFormat = 'MM/DD/YYYY';
  String _selectedCountryCode = 'US';

  static const List<String> _timezones = [
    '(GMT-08:00) Pacific Time (US & Canada)',
    '(GMT-07:00) Mountain Time (US & Canada)',
    '(GMT-06:00) Central Time (US & Canada)',
    '(GMT-05:00) Eastern Time (US & Canada)',
    '(GMT+00:00) London',
  ];

  static const List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Portuguese',
  ];

  static const List<String> _dateFormats = [
    'MM/DD/YYYY',
    'DD/MM/YYYY',
    'YYYY-MM-DD',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _departmentController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Wire up real "save profile" API call.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  void _handleChangePhoto() {
    // TODO: Wire up image picker (camera / gallery) integration.
  }

  void _handleDeleteAccount() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account'),
        content: const Text(
          'This action is permanent and cannot be undone. Are you sure you want to delete your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // TODO: Wire up real "delete account" API call.
            },
            style: TextButton.styleFrom(
              foregroundColor: context.appColors.danger,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: _EditProfileAppBar(onSave: _handleSave),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfilePhotoCard(onChangePhoto: _handleChangePhoto),
                const SizedBox(height: 20),
                _PersonalInformationCard(
                  fullNameController: _fullNameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  jobTitleController: _jobTitleController,
                  departmentController: _departmentController,
                  bioController: _bioController,
                  bioMaxLength: _bioMaxLength,
                  selectedCountryCode: _selectedCountryCode,
                  onCountryCodeChanged: (value) {
                    setState(() => _selectedCountryCode = value);
                  },
                  onBioChanged: () => setState(() {}),
                ),
                const SizedBox(height: 20),
                _AdditionalInformationCard(
                  selectedTimezone: _selectedTimezone,
                  timezones: _timezones,
                  onTimezoneChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedTimezone = value);
                    }
                  },
                  selectedLanguage: _selectedLanguage,
                  languages: _languages,
                  onLanguageChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedLanguage = value);
                    }
                  },
                  selectedDateFormat: _selectedDateFormat,
                  dateFormats: _dateFormats,
                  onDateFormatChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedDateFormat = value);
                    }
                  },
                ),
                const SizedBox(height: 24),
                _DeleteAccountButton(onPressed: _handleDeleteAccount),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 3, // Profile tab
        onTabSelected: (index) {
          // TODO: Wire up navigation between screens.
        },
        onCenterTap: () {
          // TODO: Wire up center FAB action (e.g., quick-add task/event).
        },
      ),
    );
  }
}

/// Custom AppBar matching the "Edit Profile" spec: title + subtitle on the
/// left, back arrow leading, and a filled "Save" button trailing.
class _EditProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _EditProfileAppBar({required this.onSave});

  final VoidCallback onSave;

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      backgroundColor: colors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      titleSpacing: 4,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Update your personal information',
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: _SaveButton(onPressed: onSave),
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: const Text(
        'Save',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}

/// Shared card container used by all sections on this screen.
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Profile Photo section: circular avatar with a camera badge, title/caption
/// text, and an outlined "Change Photo" button.
class _ProfilePhotoCard extends StatelessWidget {
  const _ProfilePhotoCard({required this.onChangePhoto});

  final VoidCallback onChangePhoto;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return _SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AvatarWithCameraBadge(colors: colors),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Photo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'JPG, PNG or GIF. Max size 5MB.',
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onChangePhoto,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.primary,
                    side: BorderSide(color: colors.primary),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Change Photo',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarWithCameraBadge extends StatelessWidget {
  const _AvatarWithCameraBadge({required this.colors});

  final AppColorsExt colors;

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 40;

    return SizedBox(
      width: avatarRadius * 2 + 6,
      height: avatarRadius * 2 + 6,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: colors.border,
            // TODO: Replace with the real user avatar (NetworkImage/FileImage).
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/160?img=13',
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.person,
                  size: avatarRadius,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: colors.cardBackground, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Personal Information card containing all standard text form fields plus
/// the split country-code + phone number row and the bio counter field.
class _PersonalInformationCard extends StatelessWidget {
  const _PersonalInformationCard({
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.jobTitleController,
    required this.departmentController,
    required this.bioController,
    required this.bioMaxLength,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
    required this.onBioChanged,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController jobTitleController;
  final TextEditingController departmentController;
  final TextEditingController bioController;
  final int bioMaxLength;
  final String selectedCountryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final VoidCallback onBioChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _LabeledTextField(
            label: 'Full Name',
            controller: fullNameController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),
          _LabeledTextField(
            label: 'Email Address',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),
          _PhoneField(
            label: 'Phone Number',
            countryCode: selectedCountryCode,
            onCountryCodeChanged: onCountryCodeChanged,
            controller: phoneController,
          ),
          const SizedBox(height: 18),
          _LabeledTextField(
            label: 'Job Title',
            controller: jobTitleController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),
          _LabeledTextField(
            label: 'Department',
            controller: departmentController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 18),
          _BioField(
            controller: bioController,
            maxLength: bioMaxLength,
            onChanged: onBioChanged,
          ),
        ],
      ),
    );
  }
}

/// Standard labeled single-line text field: muted label above a bordered
/// input, matching the reference mockup exactly (label is not hint text).
class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.textInputAction,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: TextStyle(fontSize: 15, color: colors.textPrimary),
          decoration: _fieldDecoration(colors),
        ),
      ],
    );
  }
}

/// Split phone number row: country code selector (flag + code + dropdown
/// arrow) on the left, main phone field on the right.
class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.label,
    required this.countryCode,
    required this.onCountryCodeChanged,
    required this.controller,
  });

  final String label;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final TextEditingController controller;

  static const Map<String, String> _dialCodes = {
    'US': '+1',
    'GB': '+44',
    'CA': '+1',
    'AU': '+61',
  };

  static const Map<String, String> _flagEmojis = {
    'US': '🇺🇸',
    'GB': '🇬🇧',
    'CA': '🇨🇦',
    'AU': '🇦🇺',
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 52,
              decoration: BoxDecoration(
                border: Border.all(color: colors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: countryCode,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: colors.textSecondary,
                  ),
                  items: _dialCodes.keys
                      .map(
                        (code) => DropdownMenuItem(
                          value: code,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _flagEmojis[code] ?? '',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _dialCodes[code] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: colors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onCountryCodeChanged(value);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                style: TextStyle(fontSize: 15, color: colors.textPrimary),
                decoration: _fieldDecoration(colors),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Multi-line Bio field with a live "current/max" character counter aligned
/// to the bottom-right, matching the reference mockup.
class _BioField extends StatefulWidget {
  const _BioField({
    required this.controller,
    required this.maxLength,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int maxLength;
  final VoidCallback onChanged;

  @override
  State<_BioField> createState() => _BioFieldState();
}

class _BioFieldState extends State<_BioField> {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final currentLength = widget.controller.text.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          maxLength: widget.maxLength,
          maxLines: 3,
          inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
          style: TextStyle(fontSize: 15, color: colors.textPrimary),
          decoration: _fieldDecoration(
            colors,
          ).copyWith(counterText: '', contentPadding: const EdgeInsets.all(14)),
          onChanged: (_) {
            setState(() {});
            widget.onChanged();
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '$currentLength/${widget.maxLength}',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}

/// Additional Information card containing the timezone, language, and date
/// format dropdown fields.
class _AdditionalInformationCard extends StatelessWidget {
  const _AdditionalInformationCard({
    required this.selectedTimezone,
    required this.timezones,
    required this.onTimezoneChanged,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageChanged,
    required this.selectedDateFormat,
    required this.dateFormats,
    required this.onDateFormatChanged,
  });

  final String selectedTimezone;
  final List<String> timezones;
  final ValueChanged<String?> onTimezoneChanged;

  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String?> onLanguageChanged;

  final String selectedDateFormat;
  final List<String> dateFormats;
  final ValueChanged<String?> onDateFormatChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Additional Information',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _LabeledDropdownField(
            label: 'Timezone',
            value: selectedTimezone,
            items: timezones,
            onChanged: onTimezoneChanged,
          ),
          const SizedBox(height: 18),
          _LabeledDropdownField(
            label: 'Language',
            value: selectedLanguage,
            items: languages,
            onChanged: onLanguageChanged,
          ),
          const SizedBox(height: 18),
          _LabeledDropdownField(
            label: 'Date Format',
            value: selectedDateFormat,
            items: dateFormats,
            onChanged: onDateFormatChanged,
          ),
        ],
      ),
    );
  }
}

/// Standard labeled dropdown field with a custom trailing arrow icon.
class _LabeledDropdownField extends StatelessWidget {
  const _LabeledDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: colors.textSecondary,
              ),
              style: TextStyle(fontSize: 15, color: colors.textPrimary),
              items: items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-width outlined "Delete Account" danger-zone action.
class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.danger,
        side: BorderSide(color: colors.danger),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: const Icon(Icons.delete_outline, size: 20),
      label: const Text(
        'Delete Account',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Shared bordered input decoration used by all text fields on this screen.
InputDecoration _fieldDecoration(AppColorsExt colors) {
  return InputDecoration(
    filled: true,
    fillColor: colors.cardBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.primary, width: 1.5),
    ),
  );
}

// -----------------------------------------------------------------------
// Standalone runnable entry point (useful for isolated preview/testing).
// Remove this section if importing EditProfileScreen into the main app.
// -----------------------------------------------------------------------
void main() {
  runApp(const _EditProfilePreviewApp());
}

class _EditProfilePreviewApp extends StatelessWidget {
  const _EditProfilePreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edit Profile Preview',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        extensions: const [AppColorsExt.light],
      ),
      home: const EditProfileScreen(),
    );
  }
}
