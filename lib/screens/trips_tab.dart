import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../providers/trips_provider.dart';
import '../widgets/trip_card.dart';

class TripsTab extends ConsumerWidget {
  const TripsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Shared Trips',
                  style: Theme.of(context).textTheme.headlineSmall),
              Text(
                '${trips.where((t) => t.hasSeats).length} available',
                style: const TextStyle(
                    color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),
        ),
        if (trips.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Text('No trips available',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          )
        else
          ...trips.map((trip) => TripCard(
                trip: trip,
                onJoin: trip.hasSeats
                    ? () => _joinTrip(context, ref, trip.id)
                    : null,
              )),
        const SizedBox(height: 12),
      ],
    );
  }

  void _joinTrip(BuildContext context, WidgetRef ref, String tripId) {
    try {
      final updated = ref
          .read(tripsProvider.notifier)
          .joinTrip(tripId, 'user_${DateTime.now().millisecondsSinceEpoch}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Joined! ${updated.availableSeats} seat(s) remaining.',
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    } on StateError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
