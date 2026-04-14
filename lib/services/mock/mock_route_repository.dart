import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/utils/polyline_utils.dart';
import '../../models/route_model.dart';
import '../interfaces/i_route_repository.dart';

class MockRouteRepository implements IRouteRepository {
  // ── Route 1 – Primary route via main road (Hebron Mall → Ibrahimi Mosque) ──
  static const List<LatLng> _route1Points = [
    LatLng(31.5445, 35.0791), // Hebron Mall
    LatLng(31.5430, 35.0820),
    LatLng(31.5415, 35.0855),
    LatLng(31.5400, 35.0880),
    LatLng(31.5380, 35.0910),
    LatLng(31.5360, 35.0940), // Al-Manara Square area
    LatLng(31.5340, 35.0965),
    LatLng(31.5315, 35.0990),
    LatLng(31.5290, 35.1020),
    LatLng(31.5270, 35.1055),
    LatLng(31.5255, 35.1075),
    LatLng(31.5243, 35.1098), // Ibrahimi Mosque
  ];

  // ── Route 2 – Alternative via northern bypass ──────────────────────────────
  static const List<LatLng> _route2Points = [
    LatLng(31.5445, 35.0791), // Hebron Mall
    LatLng(31.5460, 35.0810),
    LatLng(31.5480, 35.0845),
    LatLng(31.5490, 35.0885),
    LatLng(31.5475, 35.0930),
    LatLng(31.5455, 35.0975),
    LatLng(31.5430, 35.1010),
    LatLng(31.5400, 35.1045),
    LatLng(31.5360, 35.1070),
    LatLng(31.5320, 35.1085),
    LatLng(31.5278, 35.1093),
    LatLng(31.5243, 35.1098), // Ibrahimi Mosque
  ];

  // ── Route 3 – Southern bypass (longer but avoids checkpoints) ─────────────
  static const List<LatLng> _route3Points = [
    LatLng(31.5445, 35.0791), // Hebron Mall
    LatLng(31.5420, 35.0770),
    LatLng(31.5390, 35.0750),
    LatLng(31.5350, 35.0740),
    LatLng(31.5300, 35.0755),
    LatLng(31.5265, 35.0780),
    LatLng(31.5245, 35.0820),
    LatLng(31.5232, 35.0870),
    LatLng(31.5230, 35.0930),
    LatLng(31.5235, 35.0990),
    LatLng(31.5240, 35.1050),
    LatLng(31.5243, 35.1098), // Ibrahimi Mosque
  ];

  static final List<RouteModel> _routes = [
    const RouteModel(
      id: 'route1',
      name: 'Main Road',
      points: _route1Points,
      distanceKm: 3.2,
      etaMinutes: 12,
      isPrimary: true,
    ),
    const RouteModel(
      id: 'route2',
      name: 'Northern Bypass',
      points: _route2Points,
      distanceKm: 4.1,
      etaMinutes: 16,
      isPrimary: false,
    ),
    const RouteModel(
      id: 'route3',
      name: 'Southern Bypass',
      points: _route3Points,
      distanceKm: 5.0,
      etaMinutes: 20,
      isPrimary: false,
    ),
  ];

  @override
  List<RouteModel> getRoutes() => List.unmodifiable(_routes);

  @override
  List<RouteModel> evaluateRoutes(
    List<RouteModel> routes,
    List<({double lat, double lng})> reportPositions,
  ) {
    final appReports = reportPositions
        .map((p) => AppLatLng(p.lat, p.lng))
        .toList();

    return routes.map((route) {
      final appPoints =
          route.points.map((p) => AppLatLng(p.latitude, p.longitude)).toList();
      final affected = isRouteAffected(appPoints, appReports);
      return route.copyWith(isAffectedByReport: affected);
    }).toList();
  }
}
