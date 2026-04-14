import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/constants.dart';

enum ReportType { traffic, checkpoint, roadClosed }

extension ReportTypeLabel on ReportType {
  String get label {
    switch (this) {
      case ReportType.traffic:
        return 'Traffic Jam';
      case ReportType.checkpoint:
        return 'Checkpoint';
      case ReportType.roadClosed:
        return 'Road Closed';
    }
  }

  String get emoji {
    switch (this) {
      case ReportType.traffic:
        return '🚗';
      case ReportType.checkpoint:
        return '🚔';
      case ReportType.roadClosed:
        return '🚧';
    }
  }
}

class RoadReport {
  final String id;
  final ReportType type;
  final LatLng position;
  final String description;
  final int votes;
  final DateTime createdAt;
  final bool userHasVoted;

  const RoadReport({
    required this.id,
    required this.type,
    required this.position,
    required this.description,
    required this.votes,
    required this.createdAt,
    this.userHasVoted = false,
  });

  /// A report is "active" (shown on map) when votes >= threshold.
  bool get isActive => votes >= AppConstants.reportVoteThreshold;

  RoadReport copyWith({
    String? id,
    ReportType? type,
    LatLng? position,
    String? description,
    int? votes,
    DateTime? createdAt,
    bool? userHasVoted,
  }) =>
      RoadReport(
        id: id ?? this.id,
        type: type ?? this.type,
        position: position ?? this.position,
        description: description ?? this.description,
        votes: votes ?? this.votes,
        createdAt: createdAt ?? this.createdAt,
        userHasVoted: userHasVoted ?? this.userHasVoted,
      );
}
