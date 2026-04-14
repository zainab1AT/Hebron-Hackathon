import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/road_report.dart';
import '../interfaces/i_report_repository.dart';

class MockReportRepository implements IReportRepository {
  final List<RoadReport> _reports = [
    RoadReport(
      id: 'r1',
      type: ReportType.traffic,
      position: const LatLng(31.5300, 35.0980),
      description: 'Heavy traffic jam near Al-Manara Square',
      votes: 5,
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    RoadReport(
      id: 'r2',
      type: ReportType.checkpoint,
      position: const LatLng(31.5350, 35.0940),
      description: 'Military checkpoint on Hebron-Bethlehem road',
      votes: 8,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    RoadReport(
      id: 'r3',
      type: ReportType.roadClosed,
      position: const LatLng(31.5270, 35.1050),
      description: 'Road closed near Old City entrance – use detour',
      votes: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    RoadReport(
      id: 'r4',
      type: ReportType.traffic,
      position: const LatLng(31.5440, 35.0800),
      description: 'Minor congestion near Hebron Mall car park',
      votes: 2, // below threshold – not shown on map
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    RoadReport(
      id: 'r5',
      type: ReportType.roadClosed,
      position: const LatLng(31.5390, 35.0860),
      description: 'Road works on University Road – single lane',
      votes: 4,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    RoadReport(
      id: 'r6',
      type: ReportType.checkpoint,
      position: const LatLng(31.5200, 35.0920),
      description: 'Checkpoint at southern Hebron exit towards Yatta',
      votes: 6,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    RoadReport(
      id: 'r7',
      type: ReportType.traffic,
      position: const LatLng(31.5320, 35.0750),
      description: 'Slow traffic on western bypass',
      votes: 1, // below threshold – not shown on map
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    RoadReport(
      id: 'r8',
      type: ReportType.traffic,
      position: const LatLng(31.5415, 35.0905),
      description: 'Traffic congestion near Al-Ahli Hospital',
      votes: 3,
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  @override
  List<RoadReport> getAll() => List.unmodifiable(_reports);

  @override
  List<RoadReport> getActive() =>
      _reports.where((r) => r.isActive).toList(growable: false);

  @override
  RoadReport upvote(String reportId) {
    final idx = _reports.indexWhere((r) => r.id == reportId);
    if (idx == -1) throw StateError('Report $reportId not found');
    final updated = _reports[idx].copyWith(
      votes: _reports[idx].votes + 1,
      userHasVoted: true,
    );
    _reports[idx] = updated;
    return updated;
  }
}
