import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/driver.dart';

/// Bottom sheet shown when a driver is tapped or auto-selected.
class DriverSheet extends StatelessWidget {
  final Driver driver;
  final double? estimatedPrice;
  final double? etaMinutes;
  final VoidCallback onBook;
  final VoidCallback onDismiss;

  const DriverSheet({
    super.key,
    required this.driver,
    this.estimatedPrice,
    this.etaMinutes,
    required this.onBook,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textHint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _Avatar(initials: driver.initials),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(driver.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        '${driver.vehicleColor} ${driver.vehicleModel}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        driver.licensePlate,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _RatingBadge(rating: driver.rating),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                if (estimatedPrice != null)
                  _InfoTile(
                    icon: Icons.payments_outlined,
                    label: 'Est. Fare',
                    value: '₪${estimatedPrice!.toStringAsFixed(0)}',
                  ),
                const SizedBox(width: 12),
                if (etaMinutes != null)
                  _InfoTile(
                    icon: Icons.access_time_outlined,
                    label: 'ETA',
                    value: '${etaMinutes!.toStringAsFixed(0)} min',
                  ),
                const SizedBox(width: 12),
                _InfoTile(
                  icon: Icons.speed_outlined,
                  label: 'Rate',
                  value: '₪${driver.pricePerKm}/km',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: ElevatedButton(
              onPressed: onBook,
              child: const Text('Book this Ride'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: TextButton(
              onPressed: onDismiss,
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  const _Avatar({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;
  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.primary, size: 16),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 18),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            Text(label,
                style: const TextStyle(
                    color: AppColors.textHint, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
