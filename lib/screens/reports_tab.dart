import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../core/constants.dart';
import '../providers/reports_provider.dart';
import '../widgets/report_card.dart';

class ReportsTab extends ConsumerWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final activeReports = reports.where((r) => r.isActive).toList();
    final pendingReports =
        reports.where((r) => !r.isActive).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Road Reports',
                  style: Theme.of(context).textTheme.headlineSmall),
              _ThresholdBadge(),
            ],
          ),
        ),
        if (activeReports.isNotEmpty) ...[
          _SectionHeader(
              label: 'Active (${activeReports.length})',
              color: AppColors.error),
          ...activeReports.map((r) => ReportCard(
                report: r,
                onUpvote: () =>
                    ref.read(reportsProvider.notifier).upvote(r.id),
              )),
        ],
        if (pendingReports.isNotEmpty) ...[
          const _SectionHeader(
              label: 'Pending — need votes to show on map',
              color: AppColors.textSecondary),
          ...pendingReports.map((r) => ReportCard(
                report: r,
                onUpvote: () =>
                    ref.read(reportsProvider.notifier).upvote(r.id),
              )),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionHeader({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ThresholdBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${AppConstants.reportVoteThreshold}+ votes to show on map',
        style: const TextStyle(color: AppColors.textHint, fontSize: 10),
      ),
    );
  }
}
