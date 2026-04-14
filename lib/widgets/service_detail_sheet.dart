import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/gas_station.dart';
import '../models/parking_spot.dart';

// ── Parking ────────────────────────────────────────────────────────────────────

class ParkingDetailSheet extends StatelessWidget {
  final ParkingSpot spot;
  const ParkingDetailSheet({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      icon: 'P',
      iconColor: AppColors.secondary,
      title: spot.name,
      subtitle: spot.isCovered ? 'Covered Parking' : 'Open Parking',
      children: [
        _Row(
          label: 'Availability',
          value: spot.availabilityLabel,
          valueColor: spot.availableSpots == 0
              ? AppColors.error
              : spot.availableSpots <= 5
                  ? AppColors.warning
                  : AppColors.primary,
        ),
        _Row(
            label: 'Total Spots',
            value: '${spot.totalSpots}'),
        _Row(
            label: 'Price',
            value: spot.pricePerHour == 0
                ? 'Free'
                : '₪${spot.pricePerHour.toStringAsFixed(1)}/hour'),
        _Row(
            label: 'Covered',
            value: spot.isCovered ? 'Yes' : 'No'),
        const SizedBox(height: 8),
        _OccupancyBar(percent: spot.occupancyPercent / 100),
      ],
    );
  }
}

// ── Gas station ────────────────────────────────────────────────────────────────

class GasDetailSheet extends StatelessWidget {
  final GasStation station;
  const GasDetailSheet({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return _BaseSheet(
      icon: '⛽',
      iconColor: AppColors.warning,
      title: station.name,
      subtitle: station.brand,
      children: [
        _Row(
          label: 'Status',
          value: station.isOpen ? 'Open' : 'Closed',
          valueColor:
              station.isOpen ? AppColors.primary : AppColors.error,
        ),
        _Row(
            label: 'Price',
            value: '₪${station.pricePerLiter.toStringAsFixed(2)}/L'),
        _Row(
            label: 'Fuel Types',
            value: station.fuelTypes.join(', ')),
      ],
    );
  }
}

// ── Shared base ────────────────────────────────────────────────────────────────

class _BaseSheet extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _BaseSheet({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: AppColors.textHint,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withValues(alpha: 0.15)),
                child: Center(
                  child: Text(icon,
                      style: TextStyle(fontSize: 20, color: iconColor)),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(subtitle,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _Row({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value,
              style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

class _OccupancyBar extends StatelessWidget {
  final double percent; // 0.0 – 1.0
  const _OccupancyBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final color = percent > 0.9
        ? AppColors.error
        : percent > 0.6
            ? AppColors.warning
            : AppColors.primary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Occupancy',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            Text('${(percent * 100).round()}%',
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
