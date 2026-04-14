import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobility_mvp/core/constants.dart';
import 'package:mobility_mvp/models/road_report.dart';
import 'package:mobility_mvp/services/mock/mock_report_repository.dart';

void main() {
  group('Report activation threshold', () {
    test('report with votes >= threshold is active', () {
      final report = RoadReport(
        id: 'test1',
        type: ReportType.traffic,
        position: const LatLng(31.5300, 35.0980),
        description: 'Test report',
        votes: AppConstants.reportVoteThreshold,
        createdAt: DateTime.now(),
      );
      expect(report.isActive, isTrue);
    });

    test('report with votes < threshold is not active', () {
      final report = RoadReport(
        id: 'test2',
        type: ReportType.checkpoint,
        position: const LatLng(31.5300, 35.0980),
        description: 'Test report',
        votes: AppConstants.reportVoteThreshold - 1,
        createdAt: DateTime.now(),
      );
      expect(report.isActive, isFalse);
    });

    test('getActive() only returns reports meeting threshold', () {
      final repo = MockReportRepository();
      final all = repo.getAll();
      final active = repo.getActive();

      // All active reports must have votes >= threshold
      for (final r in active) {
        expect(r.votes, greaterThanOrEqualTo(AppConstants.reportVoteThreshold),
            reason: '${r.id} should meet the threshold');
      }

      // Active count must equal filtered count
      final expected =
          all.where((r) => r.votes >= AppConstants.reportVoteThreshold).length;
      expect(active.length, expected);
    });

    test('upvote increments votes and may activate a pending report', () {
      final repo = MockReportRepository();
      // r7 has 1 vote (below threshold)
      final before = repo.getAll().firstWhere((r) => r.id == 'r7');
      expect(before.isActive, isFalse);

      // Upvote until it crosses the threshold
      for (int i = before.votes;
          i < AppConstants.reportVoteThreshold;
          i++) {
        repo.upvote('r7');
      }
      final after = repo.getAll().firstWhere((r) => r.id == 'r7');
      expect(after.votes, greaterThanOrEqualTo(AppConstants.reportVoteThreshold));
      expect(after.isActive, isTrue);
    });
  });
}
