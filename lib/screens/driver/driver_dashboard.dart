import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_role.dart';
import '../../providers/repository_providers.dart';
import '../../providers/role_provider.dart';
import '../../widgets/role_switcher.dart';

class DriverDashboard extends ConsumerWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(driverStatusProvider);
    final isOnDuty = status == DriverStatus.onDuty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Duty toggle ─────────────────────────────────────────────────
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: DriverDutyToggle(),
        ),

        // ── Content based on duty status ────────────────────────────────
        if (isOnDuty)
          _OnDutyContent()
        else
          _OffDutyContent(),
      ],
    );
  }
}

/// Shown when driver is ON DUTY – incoming requests and active trip.
class _OnDutyContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock incoming ride requests (derived from available trips)
    final trips = ref.watch(tripRepositoryProvider).getAll();
    final incomingRequests = trips.where((t) => t.hasSeats).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Stats row ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _StatCard(
                icon: Icons.route_rounded,
                label: 'Trips Today',
                value: '7',
                color: AppColors.primary,
              ),
              const SizedBox(width: 10),
              _StatCard(
                icon: Icons.payments_outlined,
                label: 'Earnings',
                value: '₪248',
                color: AppColors.success,
              ),
              const SizedBox(width: 10),
              _StatCard(
                icon: Icons.star_rounded,
                label: 'Rating',
                value: '4.8',
                color: AppColors.warning,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ── Incoming requests ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Incoming Requests',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 8),
        if (incomingRequests.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded,
                      size: 40, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text('No requests right now',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          )
        else
          ...incomingRequests.map((trip) => _RequestCard(
                origin: trip.origin,
                destination: trip.destination,
                passengers: trip.totalSeats - trip.availableSeats,
                price: trip.pricePerSeat *
                    (trip.totalSeats - trip.availableSeats),
                onAccept: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Accepted trip to ${trip.destination}'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                onDecline: () {},
              )),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Shown when driver is OFF DUTY – trip history and stats.
class _OffDutyContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Today's summary ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                const Icon(Icons.coffee_rounded,
                    size: 40, color: AppColors.textHint),
                const SizedBox(height: 12),
                Text(
                  'You\'re off duty',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Toggle "Accepting Passengers" above to start receiving ride requests.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Recent trips ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Recent Trips',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 8),
        _TripHistoryItem(
          origin: 'City Centre',
          destination: 'Hebron Mall',
          time: '2h ago',
          earning: '₪28',
        ),
        _TripHistoryItem(
          origin: 'Hebron University',
          destination: 'Old City',
          time: '4h ago',
          earning: '₪35',
        ),
        _TripHistoryItem(
          origin: 'Industrial Zone',
          destination: 'Al-Ahli Hospital',
          time: 'Yesterday',
          earning: '₪22',
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ── Sub-components ──────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: AppColors.textHint, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final String origin;
  final String destination;
  final int passengers;
  final double price;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestCard({
    required this.origin,
    required this.destination,
    required this.passengers,
    required this.price,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.radio_button_checked,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(origin,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Container(width: 2, height: 10, color: AppColors.divider),
          ),
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 14, color: AppColors.error),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(destination,
                      style: Theme.of(context).textTheme.titleMedium)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _Tag(
                  icon: Icons.person_outline,
                  label: '$passengers pax'),
              const SizedBox(width: 8),
              _Tag(
                  icon: Icons.payments_outlined,
                  label: '₪${price.toStringAsFixed(0)}'),
              const Spacer(),
              SizedBox(
                height: 36,
                child: OutlinedButton(
                  onPressed: onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.divider),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Skip', style: TextStyle(fontSize: 13)),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    minimumSize: Size.zero,
                  ),
                  child:
                      const Text('Accept', style: TextStyle(fontSize: 13)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Tag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TripHistoryItem extends StatelessWidget {
  final String origin;
  final String destination;
  final String time;
  final String earning;

  const _TripHistoryItem({
    required this.origin,
    required this.destination,
    required this.time,
    required this.earning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
            ),
            child: const Icon(Icons.route_rounded,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$origin → $destination',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(time,
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          Text(
            earning,
            style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
