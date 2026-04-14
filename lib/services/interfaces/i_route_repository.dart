import '../../models/route_model.dart';

abstract class IRouteRepository {
  /// Returns all pre-generated routes between the mock origin and destination.
  List<RouteModel> getRoutes();

  /// Marks routes as affected/unaffected based on active report positions.
  List<RouteModel> evaluateRoutes(
      List<RouteModel> routes, List<({double lat, double lng})> reportPositions);
}
