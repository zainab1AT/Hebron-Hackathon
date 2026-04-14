import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../providers/map_providers.dart';
import '../providers/notifications_provider.dart';
import '../widgets/app_map.dart';
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

  static const double _minExtent = 0.30;
  static const double _maxExtent = 0.75;
  static const double _snapExtent = 0.50;

  final _tabs = const [
    MapMode.ride,
    MapMode.trips,
    MapMode.reports,
    MapMode.services,
  ];

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
    ref.read(mapModeProvider.notifier).state = _tabs[index];
  }

  @override
  Widget build(BuildContext context) {
    final unread = ref.watch(unreadCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Full-screen map ──────────────────────────────────────────────
          const Positioned.fill(child: AppMap()),

          // ── Top bar overlay ──────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // App logo / title
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.directions_car_filled_rounded,
                            color: AppColors.primary, size: 20),
                        SizedBox(width: 6),
                        Text(
                          'MoveHebron',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Notification bell
                  GestureDetector(
                    onTap: () => context.push('/notifications'),
                    child: Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                          if (unread > 0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                width: 10, height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 20,
                      offset: Offset(0, -4),
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
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.textHint,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // Bottom nav bar
                    Container(
                      color: AppColors.background,
                      child: BottomNavigationBar(
                        currentIndex: _currentIndex,
                        onTap: _onTabChanged,
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.directions_car_outlined),
                            activeIcon:
                                Icon(Icons.directions_car_filled_rounded),
                            label: 'Ride',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.people_outline_rounded),
                            activeIcon: Icon(Icons.people_rounded),
                            label: 'Trips',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.warning_amber_outlined),
                            activeIcon: Icon(Icons.warning_amber_rounded),
                            label: 'Reports',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.room_service_outlined),
                            activeIcon: Icon(Icons.room_service_rounded),
                            label: 'Services',
                          ),
                        ],
                      ),
                    ),
                    // Scrollable tab content
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: KeyedSubtree(
                            key: ValueKey(_currentIndex),
                            child: _buildTab(_currentIndex),
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

  Widget _buildTab(int index) {
    switch (index) {
      case 0:
        return const RideTab();
      case 1:
        return const TripsTab();
      case 2:
        return const ReportsTab();
      case 3:
        return const ServicesTab();
      default:
        return const SizedBox.shrink();
    }
  }
}
