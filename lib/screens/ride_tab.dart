import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/traffic_prediction.dart';
import '../models/driver.dart';
import '../providers/ride_provider.dart';
import '../providers/repository_providers.dart';
import '../widgets/booking_confirmation_sheet.dart';
import '../widgets/driver_sheet.dart';
import '../widgets/location_search_bar.dart';
import '../widgets/route_selector.dart';

class RideTab extends ConsumerStatefulWidget {
  const RideTab({super.key});

  @override
  ConsumerState<RideTab> createState() => _RideTabState();
}

class _RideTabState extends ConsumerState<RideTab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ride = ref.watch(rideProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Traffic prediction banner ──────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppColors.surfaceVariant,
          child: Row(
            children: [
              const Icon(Icons.traffic_rounded,
                  color: AppColors.warning, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  getTrafficPrediction(),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        ),

        // ── Search panel ──────────────────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: [
              LocationSearchBar(
                hint: 'From — pick-up location',
                value: ride.originText.isEmpty ? null : ride.originText,
                prefixIcon: Icons.radio_button_checked,
                prefixColor: AppColors.primary,
                onSelected: (name, pos) =>
                    ref.read(rideProvider.notifier).setOrigin(name, pos),
              ),
              const SizedBox(height: 8),
              LocationSearchBar(
                hint: 'To — drop-off location',
                value: ride.destinationText.isEmpty
                    ? null
                    : ride.destinationText,
                prefixIcon: Icons.location_on_rounded,
                prefixColor: AppColors.error,
                onSelected: (name, pos) =>
                    ref.read(rideProvider.notifier).setDestination(name, pos),
              ),
            ],
          ),
        ),

        // ── Routes section ────────────────────────────────────────────────
        if (ride.routes.isNotEmpty) ...[
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${ride.routes.length} routes found',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: AppColors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: RouteSelector(
                routes: ride.routes,
                selectedId: ride.selectedRouteId,
                onSelect: (id) =>
                    ref.read(rideProvider.notifier).selectRoute(id),
              ),
            ),
        ],

        // ── Nearby drivers list ───────────────────────────────────────────
        if (ride.status == RideStatus.searching) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Nearby Drivers',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
          const SizedBox(height: 8),
          _NearbyDriversList(
            originLatLng: ride.originLatLng,
            selectedDriverId: ride.selectedDriver?.id,
            onDriverTap: (driver) =>
                _showDriverSheet(context, driver, ride),
          ),
        ],

        const SizedBox(height: 12),
      ],
    );
  }

  void _showDriverSheet(BuildContext context, Driver driver, RideState ride) {
    ref.read(rideProvider.notifier).selectDriver(driver);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DriverSheet(
        driver: driver,
        estimatedPrice: ref.read(rideProvider.notifier).estimatedPrice,
        etaMinutes: ride.selectedRoute?.etaMinutes.toDouble(),
        onBook: () {
          Navigator.pop(context);
          ref.read(rideProvider.notifier).confirmBooking();
          _showConfirmation(context);
        },
        onDismiss: () => Navigator.pop(context),
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    final ride = ref.read(rideProvider);
    final driver = ride.selectedDriver;
    final route = ride.selectedRoute;
    final price = ref.read(rideProvider.notifier).estimatedPrice ?? 0;
    if (driver == null || route == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BookingConfirmationSheet(
        driver: driver,
        route: route,
        price: price,
        onDone: () {
          Navigator.pop(context);
          ref.read(rideProvider.notifier).reset();
        },
      ),
    );
  }
}

class _NearbyDriversList extends ConsumerWidget {
  final LatLng? originLatLng;
  final String? selectedDriverId;
  final void Function(Driver) onDriverTap;

  const _NearbyDriversList({
    required this.originLatLng,
    required this.selectedDriverId,
    required this.onDriverTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref
        .watch(driverRepositoryProvider.select((repo) => repo.getAvailable()));

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: drivers.length,
        itemBuilder: (_, i) {
          final d = drivers[i];
          final isSelected = d.id == selectedDriverId;
          return GestureDetector(
            onTap: () => onDriverTap(d),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isSelected
                        ? AppColors.primary
                        : AppColors.surface,
                    child: Text(
                      d.initials,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.black
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    d.name.split(' ').first,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 10, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Text(
                        d.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
