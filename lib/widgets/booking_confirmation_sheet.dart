import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/driver.dart';
import '../models/route_model.dart';

class BookingConfirmationSheet extends StatelessWidget {
  final Driver driver;
  final RouteModel route;
  final double price;
  final VoidCallback onDone;

  const BookingConfirmationSheet({
    super.key,
    required this.driver,
    required this.route,
    required this.price,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text('Ride Booked!',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            'Your driver is on the way',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _ConfirmRow(label: 'Driver', value: driver.name),
          const Divider(height: 24),
          _ConfirmRow(
              label: 'Vehicle',
              value: '${driver.vehicleColor} ${driver.vehicleModel}'),
          const Divider(height: 24),
          _ConfirmRow(label: 'Plate', value: driver.licensePlate),
          const Divider(height: 24),
          _ConfirmRow(label: 'Route', value: route.name),
          const Divider(height: 24),
          _ConfirmRow(label: 'Distance', value: route.distanceLabel),
          const Divider(height: 24),
          _ConfirmRow(label: 'ETA', value: route.etaLabel),
          const Divider(height: 24),
          _ConfirmRow(
              label: 'Total Fare',
              value: '₪${price.toStringAsFixed(0)}',
              highlight: true),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: onDone,
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;
  const _ConfirmRow(
      {required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium),
        Text(
          value,
          style: highlight
              ? const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 16)
              : Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
