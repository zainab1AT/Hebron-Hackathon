import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_role.dart';
import '../../providers/role_provider.dart';

class RoleOnboarding extends ConsumerStatefulWidget {
  const RoleOnboarding({super.key});

  @override
  ConsumerState<RoleOnboarding> createState() => _RoleOnboardingState();
}

class _RoleOnboardingState extends ConsumerState<RoleOnboarding> {
  int _page = 0;
  final _selectedRoles = <UserRole>{UserRole.passenger};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _page == 0 ? _WelcomePage(
              key: const ValueKey(0),
              onNext: () => setState(() => _page = 1),
            ) : _RolePickPage(
              key: const ValueKey(1),
              selectedRoles: _selectedRoles,
              onToggle: (role) {
                setState(() {
                  if (_selectedRoles.contains(role) &&
                      _selectedRoles.length > 1) {
                    _selectedRoles.remove(role);
                  } else {
                    _selectedRoles.add(role);
                  }
                });
              },
              onComplete: _complete,
            ),
          ),
        ),
      ),
    );
  }

  void _complete() {
    final notifier = ref.read(roleProvider.notifier);
    for (final role in _selectedRoles) {
      notifier.enableRole(role);
    }
    notifier.switchRole(_selectedRoles.first);
    notifier.completeOnboarding();
  }
}

// ── Page 1: Welcome ────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomePage({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight,
          ),
          child: const Icon(Icons.directions_car_filled_rounded,
              color: AppColors.primary, size: 40),
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome to Rafeeq',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Smart mobility for Hebron.\nBook rides, share trips, report roads,\nand drive for your community.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.textSecondary, height: 1.5),
        ),
        const SizedBox(height: 32),

        // ── How roles work explanation ─────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppColors.secondary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'How roles work',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _ExplainerRow(
                icon: Icons.person_rounded,
                color: AppColors.passenger,
                text: 'Passenger — book rides, join trips, report roads',
              ),
              const SizedBox(height: 8),
              _ExplainerRow(
                icon: Icons.drive_eta_rounded,
                color: AppColors.driver,
                text: 'Driver — accept requests, toggle passenger availability',
              ),
              const SizedBox(height: 10),
              Text(
                'You can switch roles anytime from the top bar.',
                style: TextStyle(
                    color: AppColors.textHint, fontSize: 12),
              ),
            ],
          ),
        ),

        const Spacer(flex: 3),
        ElevatedButton(
          onPressed: onNext,
          child: const Text('Get Started'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _ExplainerRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _ExplainerRow(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
        ),
      ],
    );
  }
}

// ── Page 2: Role selection ─────────────────────────────────────────────────

class _RolePickPage extends StatelessWidget {
  final Set<UserRole> selectedRoles;
  final ValueChanged<UserRole> onToggle;
  final VoidCallback onComplete;

  const _RolePickPage({
    super.key,
    required this.selectedRoles,
    required this.onToggle,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text('Choose your roles',
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Select at least one. You can add more later in Settings.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 28),

        for (final role in UserRole.values) ...[
          _RoleCard(
            role: role,
            isSelected: selectedRoles.contains(role),
            onTap: () => onToggle(role),
          ),
          const SizedBox(height: 12),
        ],

        const Spacer(),

        ElevatedButton(
          onPressed: onComplete,
          child: Text(
            selectedRoles.length > 1
                ? 'Continue with ${selectedRoles.length} roles'
                : 'Continue as ${selectedRoles.first.label}',
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? role.lightColor : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? role.color : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: role.color.withValues(alpha: 0.12),
              ),
              child: Icon(role.icon, color: role.color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    role.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? role.color
                    : AppColors.surfaceVariant,
                border: Border.all(
                  color: isSelected ? role.color : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
