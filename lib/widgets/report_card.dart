import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/road_report.dart';

class ReportCard extends StatelessWidget {
  final RoadReport report;
  final VoidCallback? onUpvote;

  const ReportCard({super.key, required this.report, this.onUpvote});

  Color get _typeColor {
    switch (report.type) {
      case ReportType.traffic:
        return AppColors.traffic;
      case ReportType.checkpoint:
        return AppColors.checkpoint;
      case ReportType.roadClosed:
        return AppColors.roadClosed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _typeColor.withValues(alpha: 0.15),
              ),
              child: Center(
                child: Text(report.type.emoji,
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        report.type.label,
                        style: TextStyle(
                          color: _typeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!report.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('Pending',
                              style: TextStyle(
                                  color: AppColors.textHint, fontSize: 10)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(report.description,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(report.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Vote button
            _VoteButton(
              votes: report.votes,
              hasVoted: report.userHasVoted,
              onTap: report.userHasVoted ? null : onUpvote,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _VoteButton extends StatelessWidget {
  final int votes;
  final bool hasVoted;
  final VoidCallback? onTap;

  const _VoteButton(
      {required this.votes, required this.hasVoted, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: hasVoted
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasVoted ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(
              hasVoted
                  ? Icons.thumb_up_rounded
                  : Icons.thumb_up_outlined,
              color: hasVoted ? AppColors.primary : AppColors.textSecondary,
              size: 16,
            ),
            const SizedBox(height: 2),
            Text(
              '$votes',
              style: TextStyle(
                color: hasVoted ? AppColors.primary : AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
