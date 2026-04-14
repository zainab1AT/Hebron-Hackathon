import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_role.dart';
import '../../providers/role_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(roleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Profile header ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary]),
                  ),
                  child: Center(
                    child: Text(
                      profile.name.isNotEmpty
                          ? profile.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        'Active: ${profile.activeRoleLabel}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Manage Roles ────────────────────────────────────────────────
          Text('Manage Roles',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Enable or disable roles for your account. At least one role must remain active.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),

          for (final role in UserRole.values)
            _RoleToggleTile(
              role: role,
              isEnabled: profile.enabledRoles.contains(role),
              isActive: profile.activeRole == role,
              isOnly: profile.enabledRoles.length == 1 &&
                  profile.enabledRoles.contains(role),
              onToggle: (enabled) {
                if (enabled) {
                  ref.read(roleProvider.notifier).enableRole(role);
                } else {
                  _confirmDisable(context, ref, role);
                }
              },
            ),

          const SizedBox(height: 28),

          // ── Edge case: mid-trip lock ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warningLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.warning, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mid-trip safety',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Role switching and role removal are disabled during an active ride or trip for safety. Complete or cancel the trip first.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // ── Other settings ──────────────────────────────────────────────
          Text('Preferences',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          _SettingTile(
            icon: Icons.language_rounded,
            label: 'Language',
            trailing: 'English',
          ),
          _SettingTile(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            trailing: 'On',
          ),
          _SettingTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
          ),
          _SettingTile(
            icon: Icons.info_outline_rounded,
            label: 'About Rafeeq',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _confirmDisable(
      BuildContext context, WidgetRef ref, UserRole role) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Disable ${role.label}?'),
        content: Text(
          'You won\'t see ${role.label} features until you re-enable it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(roleProvider.notifier).disableRole(role);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              minimumSize: const Size(100, 40),
            ),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
  }
}

class _RoleToggleTile extends StatelessWidget {
  final UserRole role;
  final bool isEnabled;
  final bool isActive;
  final bool isOnly;
  final ValueChanged<bool> onToggle;

  const _RoleToggleTile({
    required this.role,
    required this.isEnabled,
    required this.isActive,
    required this.isOnly,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? role.color.withValues(alpha: 0.4) : AppColors.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: role.color.withValues(alpha: isEnabled ? 0.12 : 0.05),
            ),
            child: Icon(role.icon,
                color: isEnabled ? role.color : AppColors.textHint, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(role.label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    )),
                if (isActive)
                  Text('Currently active',
                      style: TextStyle(color: role.color, fontSize: 11)),
              ],
            ),
          ),
          Switch.adaptive(
            value: isEnabled,
            onChanged: isOnly ? null : onToggle,
            activeTrackColor: role.lightColor,
            activeThumbColor: role.color,
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;

  const _SettingTile({
    required this.icon,
    required this.label,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.textSecondary, size: 20),
        title: Text(label,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 14)),
        trailing: trailing != null
            ? Text(trailing!,
                style: const TextStyle(
                    color: AppColors.textHint, fontSize: 13))
            : const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 18),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        onTap: () {},
      ),
    );
  }
}
