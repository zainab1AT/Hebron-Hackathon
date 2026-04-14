import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/trip.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onJoin;

  const TripCard({super.key, required this.trip, this.onJoin});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final diff = trip.departureTime.difference(now);
    final depLabel = diff.inMinutes <= 0
        ? 'Departing now'
        : diff.inMinutes < 60
            ? 'in ${diff.inMinutes} min'
            : 'in ${diff.inHours}h ${diff.inMinutes % 60}m';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Origin → Destination
            Row(
              children: [
                const Icon(Icons.radio_button_checked,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(trip.origin,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Container(
                  width: 2, height: 14, color: AppColors.textHint),
            ),
            Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 14, color: AppColors.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(trip.destination,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                _Chip(
                  icon: Icons.person_outline,
                  label: trip.driverName,
                ),
                const SizedBox(width: 8),
                _Chip(
                  icon: Icons.access_time_outlined,
                  label: depLabel,
                ),
                const Spacer(),
                _SeatsIndicator(
                    total: trip.totalSeats, available: trip.availableSeats),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '₪${trip.pricePerSeat.toStringAsFixed(0)}/seat',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                if (trip.isFull)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Full',
                        style: TextStyle(color: AppColors.textHint)),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    onPressed: onJoin,
                    child: const Text('Join'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}

class _SeatsIndicator extends StatelessWidget {
  final int total;
  final int available;
  const _SeatsIndicator({required this.total, required this.available});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final filled = i < (total - available);
        return Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Icon(
            Icons.event_seat_rounded,
            size: 16,
            color: filled ? AppColors.primary : AppColors.textHint,
          ),
        );
      }),
    );
  }
}
