import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/road_report.dart';
import 'repository_providers.dart';

class ReportsNotifier extends StateNotifier<List<RoadReport>> {
  ReportsNotifier(super.state, this._ref);
  final Ref _ref;

  void upvote(String reportId) {
    final repo = _ref.read(reportRepositoryProvider);
    final updated = repo.upvote(reportId);
    state = [
      for (final r in state)
        if (r.id == reportId) updated else r,
    ];
  }

  List<RoadReport> get active =>
      state.where((r) => r.isActive).toList(growable: false);
}

final reportsProvider =
    StateNotifierProvider<ReportsNotifier, List<RoadReport>>((ref) {
  final repo = ref.read(reportRepositoryProvider);
  return ReportsNotifier(repo.getAll(), ref);
});

/// Derived – only active reports (votes >= threshold).
final activeReportsProvider = Provider<List<RoadReport>>((ref) {
  return ref.watch(reportsProvider).where((r) => r.isActive).toList();
});
