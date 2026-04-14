import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../models/user_role.dart';
import '../providers/role_provider.dart';

/// Persistent role indicator pill shown in the top bar.
/// Tapping opens the role-switch sheet.
class RoleIndicatorPill extends ConsumerWidget {
  const RoleIndicatorPill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(roleProvider);
    final role = profile.activeRole;
    final color = role.color;

    return GestureDetector(
      onTap: () => _showRoleSwitcher(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: role.lightColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(role.icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              profile.activeRoleLabel,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            if (profile.canSwitchRole)
              Icon(Icons.swap_horiz_rounded, color: color, size: 14),
          ],
        ),
      ),
    );
  }

  void _showRoleSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _RoleSwitcherSheet(),
    );
  }
}

/// Bottom sheet for switching between roles.
class _RoleSwitcherSheet extends ConsumerWidget {
  const _RoleSwitcherSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(roleProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Text('Switch View',
                    style: Theme.of(context).textTheme.headlineSmall),
                const Spacer(),
                Text(
                  'Active: ${profile.activeRoleLabel}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Role tiles ──────────────────────────────────────────────────
          for (final role in UserRole.values)
            _RoleTile(
              role: role,
              isEnabled: profile.enabledRoles.contains(role),
              isActive: profile.activeRole == role,
              driverStatus:
                  role == UserRole.driver ? profile.driverStatus : null,
              onTap: profile.enabledRoles.contains(role)
                  ? () {
                      ref.read(roleProvider.notifier).switchRole(role);
                      Navigator.pop(context);
                    }
                  : null,
            ),

          // ── Add role hint ───────────────────────────────────────────────
          if (profile.enabledRoles.length < UserRole.values.length)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                'Enable more roles in Settings → Manage Roles',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.textHint),
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final UserRole role;
  final bool isEnabled;
  final bool isActive;
  final DriverStatus? driverStatus;
  final VoidCallback? onTap;

  const _RoleTile({
    required this.role,
    required this.isEnabled,
    required this.isActive,
    this.driverStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? role.color : AppColors.textSecondary;
    final bgColor =
        isActive ? role.lightColor : AppColors.surfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEnabled ? bgColor : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isEnabled ? color : AppColors.textHint)
                    .withValues(alpha: 0.12),
              ),
              child: Icon(role.icon,
                  color: isEnabled ? color : AppColors.textHint, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.label,
                    style: TextStyle(
                      color: isEnabled
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (driverStatus != null && isEnabled)
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: driverStatus!.color,
                          ),
                        ),
                        Text(
                          driverStatus!.subtitle,
                          style: TextStyle(
                            color: driverStatus!.color,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      isEnabled ? role.description : 'Not enabled',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (isActive)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            else if (!isEnabled)
              Icon(Icons.lock_outline_rounded,
                  color: AppColors.textHint, size: 18),
          ],
        ),
      ),
    );
  }
}

/// Inline role toggle for use in the driver dashboard.
class DriverDutyToggle extends ConsumerWidget {
  const DriverDutyToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(driverStatusProvider);
    final isOnDuty = status == DriverStatus.onDuty;

    return GestureDetector(
      onTap: () => _confirmToggle(context, ref, isOnDuty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isOnDuty ? AppColors.successLight : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOnDuty
                ? AppColors.driverOnDuty.withValues(alpha: 0.4)
                : AppColors.divider,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnDuty
                    ? AppColors.driverOnDuty.withValues(alpha: 0.15)
                    : AppColors.textHint.withValues(alpha: 0.1),
              ),
              child: Icon(
                isOnDuty
                    ? Icons.wifi_tethering_rounded
                    : Icons.wifi_tethering_off_rounded,
                color: isOnDuty ? AppColors.driverOnDuty : AppColors.textHint,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Accepting Passengers',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status.subtitle,
                    style: TextStyle(
                      color: status.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: isOnDuty,
              onChanged: (_) => _confirmToggle(context, ref, isOnDuty),
              activeTrackColor: AppColors.successLight,
              activeThumbColor: AppColors.driverOnDuty,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmToggle(BuildContext context, WidgetRef ref, bool currentlyOn) {
    if (currentlyOn) {
      // Going off duty – confirm
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Go Off Duty?'),
          content: const Text(
            'You will stop receiving ride requests. Any active trip will not be affected.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Stay On'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(roleProvider.notifier).toggleDriverStatus();
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                minimumSize: const Size(100, 40),
              ),
              child: const Text('Go Off Duty'),
            ),
          ],
        ),
      );
    } else {
      ref.read(roleProvider.notifier).toggleDriverStatus();
    }
  }
}
