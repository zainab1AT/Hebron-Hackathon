import 'package:flutter_test/flutter_test.dart';
import 'package:mobility_mvp/core/utils/polyline_utils.dart';
import 'package:mobility_mvp/services/mock/mock_route_repository.dart';

void main() {
  group('Route selection and evaluation', () {
    final repo = MockRouteRepository();

    test('repository returns 3 routes', () {
      expect(repo.getRoutes().length, 3);
    });

    test('exactly one primary route exists', () {
      final primary = repo.getRoutes().where((r) => r.isPrimary).toList();
      expect(primary.length, 1);
    });

    test('routes are sorted by eta (primary has shortest eta)', () {
      final routes = repo.getRoutes();
      final primary = routes.firstWhere((r) => r.isPrimary);
      for (final r in routes.where((r) => !r.isPrimary)) {
        expect(primary.etaMinutes, lessThanOrEqualTo(r.etaMinutes));
      }
    });

    test('evaluateRoutes marks a route affected when a report is on it', () {
      final routes = repo.getRoutes();
      // Place a report ON the primary route (near Al-Manara, on route1)
      final reportPositions = [
        (lat: 31.5360, lng: 35.0940), // known point on route1
      ];
      final evaluated = repo.evaluateRoutes(routes, reportPositions);
      final primary = evaluated.firstWhere((r) => r.isPrimary);
      expect(primary.isAffectedByReport, isTrue);
    });

    test('evaluateRoutes does not mark a route affected when report is far away',
        () {
      final routes = repo.getRoutes();
      // Report far south of all routes
      final reportPositions = [
        (lat: 31.4000, lng: 35.0000),
      ];
      final evaluated = repo.evaluateRoutes(routes, reportPositions);
      for (final r in evaluated) {
        expect(r.isAffectedByReport, isFalse,
            reason: '${r.id} should not be affected by distant report');
      }
    });

    test('evaluateRoutes leaves routes unaffected when report list is empty',
        () {
      final routes = repo.getRoutes();
      final evaluated = repo.evaluateRoutes(routes, []);
      for (final r in evaluated) {
        expect(r.isAffectedByReport, isFalse);
      }
    });
  });

  group('Haversine distance', () {
    test('distance from a point to itself is zero', () {
      final d = minDistanceToPolyline(
        const AppLatLng(31.5300, 35.0980),
        [const AppLatLng(31.5300, 35.0980)],
      );
      expect(d, closeTo(0.0, 0.0001));
    });

    test('distance to an empty polyline is infinity', () {
      final d = minDistanceToPolyline(
        const AppLatLng(31.5300, 35.0980),
        [],
      );
      expect(d, equals(double.infinity));
    });

    test('point very close to segment returns small distance', () {
      final poly = [
        const AppLatLng(31.5300, 35.0980),
        const AppLatLng(31.5400, 35.0980),
      ];
      // Point slightly off the segment
      final d = minDistanceToPolyline(
        const AppLatLng(31.5350, 35.0990),
        poly,
      );
      expect(d, lessThan(0.2)); // less than 200 m
    });
  });
}
