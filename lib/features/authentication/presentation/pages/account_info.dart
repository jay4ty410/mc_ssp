import 'package:flutter/material.dart';

/// -----------------------------------------------------------------------
/// COLOR PALETTE
/// Centralized here for easy reuse / migration into a shared ThemeExtension.
/// -----------------------------------------------------------------------
class _AppColors {
  static const Color background = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color primaryAccent = Color(0xFF2563EB);
  static const Color primaryAccentLight = Color(0xFF3B82F6);
  static const Color iconBoxBackground = Color(0xFFEFF6FF);
  static const Color titleText = Color(0xFF0F172A);
  static const Color subtitleText = Color(0xFF64748B);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color chevron = Color(0xFF94A3B8);
}

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  // ---------------------------------------------------------------------
  // Placeholder action handlers — wire these up to real navigation/logic.
  // ---------------------------------------------------------------------
  void _onBackPressed(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  void _onEditPressed(BuildContext context) {
    // TODO: Navigate to the edit-profile flow.
  }

  void _onAvatarTap(BuildContext context) {
    // TODO: Launch image picker to update the profile photo.
  }

  void _onFieldTap(BuildContext context, String field) {
    // TODO: Navigate to the relevant edit screen for [field].
  }

  void _onNavTap(BuildContext context, int index) {
    // TODO: Handle bottom navigation switching.
  }

  void _onFabTap(BuildContext context) {
    // TODO: Handle the primary "add" action.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildPersonalDetailsSection(context),
              const SizedBox(height: 20),
              _buildAdditionalInfoSection(context),
              const SizedBox(height: 20),
              _buildAccountDetailsSection(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _AppBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) => _onNavTap(context, index),
        onFabTap: () => _onFabTap(context),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // HEADER
  // ---------------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _onBackPressed(context),
            child: const Padding(
              padding: EdgeInsets.only(top: 4, right: 8),
              child: Icon(
                Icons.arrow_back,
                color: _AppColors.titleText,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _AppColors.titleText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'View and update your personal details',
                  style: TextStyle(
                    fontSize: 13,
                    color: _AppColors.subtitleText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _EditButton(onTap: () => _onEditPressed(context)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // PERSONAL DETAILS SECTION
  // ---------------------------------------------------------------------
  Widget _buildPersonalDetailsSection(BuildContext context) {
    return _SectionCard(
      title: 'Personal Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: _AvatarWithBadge(onTap: () => _onAvatarTap(context)),
          ),
          _InfoRow(
            icon: Icons.person_outline,
            label: 'Full Name',
            value: 'Alex Johnson',
            onTap: () => _onFieldTap(context, 'full_name'),
          ),
          _InfoRow(
            icon: Icons.mail_outline,
            label: 'Email Address',
            value: 'alex.johnson@mcss.com',
            onTap: () => _onFieldTap(context, 'email'),
          ),
          _InfoRow(
            icon: Icons.phone_outlined,
            label: 'Phone Number',
            value: '+1 (555) 123-4567',
            onTap: () => _onFieldTap(context, 'phone'),
          ),
          _InfoRow(
            icon: Icons.work_outline,
            label: 'Job Title',
            value: 'Project Manager',
            onTap: () => _onFieldTap(context, 'job_title'),
          ),
          _InfoRow(
            icon: Icons.business_outlined,
            label: 'Department',
            value: 'Operations',
            onTap: () => _onFieldTap(context, 'department'),
          ),
          _InfoRow(
            icon: Icons.description_outlined,
            label: 'Bio',
            value:
                'Project manager with a passion for productivity and team collaboration.',
            onTap: () => _onFieldTap(context, 'bio'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // ADDITIONAL INFORMATION SECTION
  // ---------------------------------------------------------------------
  Widget _buildAdditionalInfoSection(BuildContext context) {
    return _SectionCard(
      title: 'Additional Information',
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.language,
            label: 'Timezone',
            value: '(GMT-05:00) Eastern Time (US & Canada)',
            onTap: () => _onFieldTap(context, 'timezone'),
          ),
          _InfoRow(
            icon: Icons.translate,
            label: 'Language',
            value: 'English',
            onTap: () => _onFieldTap(context, 'language'),
          ),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date Format',
            value: 'MM/DD/YYYY',
            onTap: () => _onFieldTap(context, 'date_format'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // ACCOUNT DETAILS SECTION
  // ---------------------------------------------------------------------
  Widget _buildAccountDetailsSection(BuildContext context) {
    return _SectionCard(
      title: 'Account Details',
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Member Since',
            value: 'April 12, 2024',
            onTap: () => _onFieldTap(context, 'member_since'),
          ),
          _InfoRow(
            icon: Icons.security_outlined,
            label: 'Account Type',
            value: '',
            trailing: const _Badge(text: 'Team Member'),
            onTap: () => _onFieldTap(context, 'account_type'),
          ),
          _InfoRow(
            icon: Icons.info_outline,
            label: 'Version',
            value: '2.4.1 (Latest)',
            onTap: () => _onFieldTap(context, 'version'),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// EDIT BUTTON (outlined, light-blue, pencil icon + label)
/// -----------------------------------------------------------------------
class _EditButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EditButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _AppColors.iconBoxBackground,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _AppColors.primaryAccentLight.withValues(alpha: 0.35),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit_outlined,
                size: 16,
                color: _AppColors.primaryAccent,
              ),
              SizedBox(width: 6),
              Text(
                'Edit',
                style: TextStyle(
                  color: _AppColors.primaryAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// SECTION WRAPPER: title above a white rounded-corner card
/// -----------------------------------------------------------------------
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _AppColors.titleText,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: _AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// REUSABLE INFO ROW: icon box + label/value + chevron, with divider.
/// Accepts an optional [trailing] widget (e.g. a pill badge) rendered
/// in place of the plain value text.
/// -----------------------------------------------------------------------
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(16))
            : BorderRadius.zero,
        child: Container(
          decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(
                    bottom: BorderSide(color: _AppColors.divider, width: 1),
                  ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _IconBox(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: _AppColors.subtitleText,
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (trailing == null)
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: _AppColors.titleText,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[trailing!, const SizedBox(width: 8)],
              const Icon(
                Icons.chevron_right,
                color: _AppColors.chevron,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Small light-blue rounded icon container used at the start of each row.
/// -----------------------------------------------------------------------
class _IconBox extends StatelessWidget {
  final IconData icon;

  const _IconBox({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: _AppColors.iconBoxBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: _AppColors.primaryAccent, size: 20),
    );
  }
}

/// -----------------------------------------------------------------------
/// Pill-shaped badge used for the "Account Type" value.
/// -----------------------------------------------------------------------
class _Badge extends StatelessWidget {
  final String text;

  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _AppColors.iconBoxBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: _AppColors.primaryAccent,
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// Circular avatar with a small blue camera badge overlapping bottom-right.
/// -----------------------------------------------------------------------
class _AvatarWithBadge extends StatelessWidget {
  final VoidCallback onTap;

  const _AvatarWithBadge({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 88,
        height: 88,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _AppColors.divider, width: 2),
              ),
              child: ClipOval(
                child: Image.network(
                  'https://i.pravatar.cc/150?img=13',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: _AppColors.iconBoxBackground,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: _AppColors.primaryAccent,
                    ),
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
                  color: _AppColors.primaryAccent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _AppColors.cardBackground,
                    width: 2.5,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----------------------------------------------------------------------
/// BOTTOM NAVIGATION BAR with a centered elevated circular FAB.
/// -----------------------------------------------------------------------
class _AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;

  const _AppBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
  });

  @override
  Widget build(BuildContext context) {
    const navItems = [
      _NavItemData(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
      ),
      _NavItemData(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today,
        label: 'Calendar',
      ),
      _NavItemData(
        icon: Icons.checklist_outlined,
        activeIcon: Icons.checklist,
        label: 'Tasks',
      ),
      _NavItemData(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    return SizedBox(
      height: 78,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: _AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 12,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    _buildNavItem(navItems[0], 0),
                    _buildNavItem(navItems[1], 1),
                    const SizedBox(width: 64), // space for the FAB
                    _buildNavItem(navItems[2], 2),
                    _buildNavItem(navItems[3], 3),
                  ],
                ),
              ),
            ),
          ),
          Positioned(top: -22, child: _CenterFab(onTap: onFabTap)),
        ],
      ),
    );
  }

  Widget _buildNavItem(_NavItemData data, int index) {
    final bool isActive = index == currentIndex;
    final color = isActive ? _AppColors.primaryAccent : _AppColors.subtitleText;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? data.activeIcon : data.icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// -----------------------------------------------------------------------
/// Elevated circular blue "+" FAB centered on the bottom nav bar.
/// -----------------------------------------------------------------------
class _CenterFab extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _AppColors.primaryAccent,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _AppColors.primaryAccent.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
