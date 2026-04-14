import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../models/user_role.dart';
import '../providers/map_providers.dart';
import '../providers/notifications_provider.dart';
import '../providers/role_provider.dart';
import '../widgets/app_map.dart';
import '../widgets/role_switcher.dart';
import 'driver/driver_dashboard.dart';
import 'reports_tab.dart';
import 'ride_tab.dart';
import 'services_tab.dart';
import 'trips_tab.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _currentIndex = 0;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  static const double _minExtent = 0.32;
  static const double _maxExtent = 0.78;
  static const double _snapExtent = 0.52;

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  /// Tabs change based on active role.
  List<_TabDef> _tabsForRole(UserRole role) {
    switch (role) {
      case UserRole.passenger:
        return const [
          _TabDef(MapMode.ride, Icons.directions_car_outlined,
              Icons.directions_car_filled_rounded, 'Ride'),
          _TabDef(MapMode.trips, Icons.people_outline_rounded,
              Icons.people_rounded, 'Trips'),
          _TabDef(MapMode.reports, Icons.warning_amber_outlined,
              Icons.warning_amber_rounded, 'Reports'),
          _TabDef(MapMode.services, Icons.local_gas_station_outlined,
              Icons.local_gas_station_rounded, 'Services'),
        ];
      case UserRole.driver:
        return const [
          _TabDef(MapMode.ride, Icons.drive_eta_outlined,
              Icons.drive_eta_rounded, 'Dashboard'),
          _TabDef(MapMode.reports, Icons.warning_amber_outlined,
              Icons.warning_amber_rounded, 'Reports'),
          _TabDef(MapMode.services, Icons.local_gas_station_outlined,
              Icons.local_gas_station_rounded, 'Services'),
        ];
    }
  }

  void _onTabChanged(int index) {
    final role = ref.read(activeRoleProvider);
    final tabs = _tabsForRole(role);
    if (index >= tabs.length) return;
    setState(() => _currentIndex = index);
    ref.read(mapModeProvider.notifier).state = tabs[index].mode;
  }

  @override
  Widget build(BuildContext context) {
    final unread = ref.watch(unreadCountProvider);
    final role = ref.watch(activeRoleProvider);
    final tabs = _tabsForRole(role);

    // Reset tab index if switching roles and current index is out of bounds
    if (_currentIndex >= tabs.length) {
      _currentIndex = 0;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Full-screen map ──────────────────────────────────────────────
          const Positioned.fill(child: AppMap()),

          // ── Top bar overlay ──────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // App logo
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.mapOverlay,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.directions_car_filled_rounded,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 6),
                        const Text(
                          'Rafeeq',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Role indicator pill
                  const RoleIndicatorPill(),

                  const Spacer(),

                  // Settings
                  _TopBarButton(
                    icon: Icons.settings_outlined,
                    onTap: () => context.push('/settings'),
                  ),
                  const SizedBox(width: 8),

                  // Notifications
                  _TopBarButton(
                    icon: Icons.notifications_outlined,
                    badgeCount: unread,
                    onTap: () => context.push('/notifications'),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom sheet panel ───────────────────────────────────────────
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: _minExtent,
            minChildSize: _minExtent,
            maxChildSize: _maxExtent,
            snap: true,
            snapSizes: const [_minExtent, _snapExtent, _maxExtent],
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Drag handle
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 4),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // Bottom nav bar
                    BottomNavigationBar(
                      currentIndex: _currentIndex,
                      onTap: _onTabChanged,
                      items: tabs
                          .map((t) => BottomNavigationBarItem(
                                icon: Icon(t.icon),
                                activeIcon: Icon(t.activeIcon),
                                label: t.label,
                              ))
                          .toList(),
                    ),
                    // Scrollable tab content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: KeyedSubtree(
                            key: ValueKey('${role.label}_$_currentIndex'),
                            child: _buildTab(role, _currentIndex),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTab(UserRole role, int index) {
    if (role == UserRole.passenger) {
      switch (index) {
        case 0:
          return const RideTab();
        case 1:
          return const TripsTab();
        case 2:
          return const ReportsTab();
        case 3:
          return const ServicesTab();
      }
    } else if (role == UserRole.driver) {
      switch (index) {
        case 0:
          return const DriverDashboard();
        case 1:
          return const ReportsTab();
        case 2:
          return const ServicesTab();
      }
    }
    return const SizedBox.shrink();
  }
}

// ── Helper types ────────────────────────────────────────────────────────────

class _TabDef {
  final MapMode mode;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _TabDef(this.mode, this.icon, this.activeIcon, this.label);
}

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _TopBarButton({
    required this.icon,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.mapOverlay,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 20),
            if (badgeCount > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
