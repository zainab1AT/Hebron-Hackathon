import '../../models/road_report.dart';

abstract class IReportRepository {
  List<RoadReport> getAll();

  /// Returns only active reports (votes >= threshold).
  List<RoadReport> getActive();

  /// Increments the vote count of [reportId] by 1.
  RoadReport upvote(String reportId);
}
