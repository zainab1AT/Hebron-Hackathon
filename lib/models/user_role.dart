import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// Roles available in Rafeeq.
/// A user account can hold multiple roles simultaneously.
enum UserRole { passenger, driver }

/// Driver sub-state: personal driving vs accepting passengers.
enum DriverStatus { offDuty, onDuty }

extension UserRoleDisplay on UserRole {
  String get label {
    switch (this) {
      case UserRole.passenger:
        return 'Passenger';
      case UserRole.driver:
        return 'Driver';
    }
  }

  String get arabicLabel {
    switch (this) {
      case UserRole.passenger:
        return 'راكب';
      case UserRole.driver:
        return 'سائق';
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.passenger:
        return Icons.person_rounded;
      case UserRole.driver:
        return Icons.drive_eta_rounded;
    }
  }

  Color get color {
    switch (this) {
      case UserRole.passenger:
        return AppColors.passenger;
      case UserRole.driver:
        return AppColors.driver;
    }
  }

  Color get lightColor {
    switch (this) {
      case UserRole.passenger:
        return AppColors.primaryLight;
      case UserRole.driver:
        return AppColors.secondaryLight;
    }
  }

  String get description {
    switch (this) {
      case UserRole.passenger:
        return 'Book rides, join shared trips, report road conditions, and find parking & gas.';
      case UserRole.driver:
        return 'Accept ride requests, manage trips, track earnings, and toggle passenger availability.';
    }
  }
}

extension DriverStatusDisplay on DriverStatus {
  String get label {
    switch (this) {
      case DriverStatus.offDuty:
        return 'Off Duty';
      case DriverStatus.onDuty:
        return 'On Duty';
    }
  }

  String get subtitle {
    switch (this) {
      case DriverStatus.offDuty:
        return 'Not accepting passengers';
      case DriverStatus.onDuty:
        return 'Accepting passengers';
    }
  }

  Color get color {
    switch (this) {
      case DriverStatus.offDuty:
        return AppColors.textSecondary;
      case DriverStatus.onDuty:
        return AppColors.driverOnDuty;
    }
  }

  Color get lightColor {
    switch (this) {
      case DriverStatus.offDuty:
        return AppColors.surfaceVariant;
      case DriverStatus.onDuty:
        return AppColors.successLight;
    }
  }
}

/// Immutable representation of the current user's profile state.
class UserProfile {
  final String id;
  final String name;
  final Set<UserRole> enabledRoles;
  final UserRole activeRole;
  final DriverStatus driverStatus;
  final bool hasCompletedOnboarding;

  const UserProfile({
    required this.id,
    required this.name,
    required this.enabledRoles,
    required this.activeRole,
    this.driverStatus = DriverStatus.offDuty,
    this.hasCompletedOnboarding = false,
  });

  bool get isDriver => enabledRoles.contains(UserRole.driver);
  bool get isPassenger => enabledRoles.contains(UserRole.passenger);
  bool get isDriverOnDuty =>
      activeRole == UserRole.driver && driverStatus == DriverStatus.onDuty;
  bool get canSwitchRole => enabledRoles.length > 1;

  /// Whether the user is mid-trip and switching should be blocked.
  bool get hasMidTripLock => false; // Set by ride/trip provider when active

  String get activeRoleLabel {
    if (activeRole == UserRole.driver) {
      return 'Driver (${driverStatus.label})';
    }
    return activeRole.label;
  }

  UserProfile copyWith({
    String? id,
    String? name,
    Set<UserRole>? enabledRoles,
    UserRole? activeRole,
    DriverStatus? driverStatus,
    bool? hasCompletedOnboarding,
  }) =>
      UserProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        enabledRoles: enabledRoles ?? this.enabledRoles,
        activeRole: activeRole ?? this.activeRole,
        driverStatus: driverStatus ?? this.driverStatus,
        hasCompletedOnboarding:
            hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      );
}
