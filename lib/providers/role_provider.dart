import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_role.dart';

/// Mock user profile – starts as passenger only, can add driver role.
class RoleNotifier extends StateNotifier<UserProfile> {
  RoleNotifier()
      : super(const UserProfile(
          id: 'user_001',
          name: 'Zainab',
          enabledRoles: {UserRole.passenger},
          activeRole: UserRole.passenger,
          hasCompletedOnboarding: false,
        ));

  // ── Role switching ──────────────────────────────────────────────────────

  /// Switches to a different role (only if enabled).
  void switchRole(UserRole role) {
    if (!state.enabledRoles.contains(role)) return;
    state = state.copyWith(activeRole: role);
  }

  // ── Driver status ───────────────────────────────────────────────────────

  void toggleDriverStatus() {
    if (state.activeRole != UserRole.driver) return;
    final next = state.driverStatus == DriverStatus.onDuty
        ? DriverStatus.offDuty
        : DriverStatus.onDuty;
    state = state.copyWith(driverStatus: next);
  }

  void setDriverStatus(DriverStatus status) {
    state = state.copyWith(driverStatus: status);
  }

  // ── Role management ─────────────────────────────────────────────────────

  void enableRole(UserRole role) {
    state = state.copyWith(
      enabledRoles: {...state.enabledRoles, role},
    );
  }

  void disableRole(UserRole role) {
    if (state.enabledRoles.length <= 1) return; // Must keep at least one
    final newRoles = {...state.enabledRoles}..remove(role);
    final newActive =
        state.activeRole == role ? newRoles.first : state.activeRole;
    state = state.copyWith(
      enabledRoles: newRoles,
      activeRole: newActive,
      driverStatus: role == UserRole.driver
          ? DriverStatus.offDuty
          : state.driverStatus,
    );
  }

  // ── Onboarding ──────────────────────────────────────────────────────────

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }
}

final roleProvider = StateNotifierProvider<RoleNotifier, UserProfile>(
  (_) => RoleNotifier(),
);

/// Convenience derived providers for select() optimisation.
final activeRoleProvider = Provider<UserRole>((ref) {
  return ref.watch(roleProvider.select((p) => p.activeRole));
});

final driverStatusProvider = Provider<DriverStatus>((ref) {
  return ref.watch(roleProvider.select((p) => p.driverStatus));
});

final hasCompletedOnboardingProvider = Provider<bool>((ref) {
  return ref.watch(roleProvider.select((p) => p.hasCompletedOnboarding));
});
