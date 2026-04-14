import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteModel {
  final String id;
  final String name;
  final List<LatLng> points;
  final double distanceKm;
  final int etaMinutes;
  final bool isPrimary;
  final bool isAffectedByReport;

  const RouteModel({
    required this.id,
    required this.name,
    required this.points,
    required this.distanceKm,
    required this.etaMinutes,
    required this.isPrimary,
    this.isAffectedByReport = false,
  });

  RouteModel copyWith({
    String? id,
    String? name,
    List<LatLng>? points,
    double? distanceKm,
    int? etaMinutes,
    bool? isPrimary,
    bool? isAffectedByReport,
  }) =>
      RouteModel(
        id: id ?? this.id,
        name: name ?? this.name,
        points: points ?? this.points,
        distanceKm: distanceKm ?? this.distanceKm,
        etaMinutes: etaMinutes ?? this.etaMinutes,
        isPrimary: isPrimary ?? this.isPrimary,
        isAffectedByReport: isAffectedByReport ?? this.isAffectedByReport,
      );

  String get etaLabel =>
      etaMinutes < 60 ? '$etaMinutes min' : '${(etaMinutes / 60).toStringAsFixed(1)} h';

  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} km';
}
