import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/route_model.dart';

class RouteSelector extends StatelessWidget {
  final List<RouteModel> routes;
  final String? selectedId;
  final ValueChanged<String> onSelect;

  const RouteSelector({
    super.key,
    required this.routes,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Choose Route',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...routes.map((route) => _RouteTile(
              route: route,
              isSelected: route.id == selectedId,
              onTap: () => onSelect(route.id),
            )),
      ],
    );
  }
}

class _RouteTile extends StatelessWidget {
  final RouteModel route;
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteTile({
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.route_rounded,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        route.name,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (route.isPrimary) ...[
                        const SizedBox(width: 8),
                        _Badge(label: 'Fastest', color: AppColors.primary),
                      ],
                      if (route.isAffectedByReport) ...[
                        const SizedBox(width: 8),
                        _Badge(label: 'Affected', color: AppColors.warning),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${route.distanceLabel} · ${route.etaLabel}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
