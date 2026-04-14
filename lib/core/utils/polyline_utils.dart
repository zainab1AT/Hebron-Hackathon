import '../constants.dart';
import 'haversine.dart';

/// A minimal lat/lng pair used in pure-Dart utilities (no platform dependency).
class AppLatLng {
  final double lat;
  final double lng;
  const AppLatLng(this.lat, this.lng);
}

/// Returns the minimum distance (km) from [point] to the polyline defined by
/// [polyline].  Uses the point-to-segment algorithm over every segment.
double minDistanceToPolyline(AppLatLng point, List<AppLatLng> polyline) {
  if (polyline.isEmpty) return double.infinity;
  if (polyline.length == 1) {
    return haversineDistance(
        point.lat, point.lng, polyline.first.lat, polyline.first.lng);
  }

  double minDist = double.infinity;
  for (int i = 0; i < polyline.length - 1; i++) {
    final d = _pointToSegmentDistance(point, polyline[i], polyline[i + 1]);
    if (d < minDist) minDist = d;
  }
  return minDist;
}

/// Checks whether any point in [reportPositions] is within
/// [AppConstants.reportRouteAffectRadius] km of the [route] polyline.
bool isRouteAffected(
    List<AppLatLng> route, List<AppLatLng> reportPositions) {
  for (final rp in reportPositions) {
    if (minDistanceToPolyline(rp, route) <=
        AppConstants.reportRouteAffectRadius) {
      return true;
    }
  }
  return false;
}

// Approximate point-to-segment distance using linear interpolation in lat/lng
// space (accurate enough for the short distances in a city).
double _pointToSegmentDistance(
    AppLatLng p, AppLatLng a, AppLatLng b) {
  final abLat = b.lat - a.lat;
  final abLng = b.lng - a.lng;
  final apLat = p.lat - a.lat;
  final apLng = p.lng - a.lng;
  final ab2 = abLat * abLat + abLng * abLng;
  if (ab2 == 0) {
    return haversineDistance(p.lat, p.lng, a.lat, a.lng);
  }
  final t = ((apLat * abLat + apLng * abLng) / ab2).clamp(0.0, 1.0);
  final closestLat = a.lat + t * abLat;
  final closestLng = a.lng + t * abLng;
  return haversineDistance(p.lat, p.lng, closestLat, closestLng);
}
