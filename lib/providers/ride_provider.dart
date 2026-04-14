import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/utils/haversine.dart';
import '../models/driver.dart';
import '../models/route_model.dart';
import 'reports_provider.dart';
import 'repository_providers.dart';

enum RideStatus { idle, searching, driverSelected, booked }

class RideState {
  final String originText;
  final String destinationText;
  final LatLng? originLatLng;
  final LatLng? destinationLatLng;
  final List<RouteModel> routes;
  final String? selectedRouteId;
  final Driver? selectedDriver;
  final RideStatus status;

  const RideState({
    this.originText = '',
    this.destinationText = '',
    this.originLatLng,
    this.destinationLatLng,
    this.routes = const [],
    this.selectedRouteId,
    this.selectedDriver,
    this.status = RideStatus.idle,
  });

  RouteModel? get selectedRoute =>
      routes.isEmpty ? null : routes.firstWhere(
        (r) => r.id == selectedRouteId,
        orElse: () => routes.first,
      );

  RideState copyWith({
    String? originText,
    String? destinationText,
    LatLng? originLatLng,
    LatLng? destinationLatLng,
    List<RouteModel>? routes,
    String? selectedRouteId,
    Driver? selectedDriver,
    RideStatus? status,
  }) =>
      RideState(
        originText: originText ?? this.originText,
        destinationText: destinationText ?? this.destinationText,
        originLatLng: originLatLng ?? this.originLatLng,
        destinationLatLng: destinationLatLng ?? this.destinationLatLng,
        routes: routes ?? this.routes,
        selectedRouteId: selectedRouteId ?? this.selectedRouteId,
        selectedDriver: selectedDriver ?? this.selectedDriver,
        status: status ?? this.status,
      );
}

class RideNotifier extends StateNotifier<RideState> {
  RideNotifier(this._ref) : super(const RideState());
  final Ref _ref;

  void setOrigin(String text, LatLng latLng) {
    state = state.copyWith(originText: text, originLatLng: latLng);
  }

  void setDestination(String text, LatLng latLng) {
    state = state.copyWith(destinationText: text, destinationLatLng: latLng);
    _loadRoutes();
  }

  void _loadRoutes() {
    final routeRepo = _ref.read(routeRepositoryProvider);
    final activeReports = _ref.read(activeReportsProvider);

    final reportPositions = activeReports
        .map((r) => (lat: r.position.latitude, lng: r.position.longitude))
        .toList();

    var routes = routeRepo.getRoutes();
    routes = routeRepo.evaluateRoutes(routes, reportPositions);

    // Auto-select best route: prefer non-affected primary, else non-affected alternative
    final best = _pickBestRoute(routes);

    state = state.copyWith(
      routes: routes,
      selectedRouteId: best.id,
      status: RideStatus.searching,
    );
    _autoSelectDriver();
  }

  RouteModel _pickBestRoute(List<RouteModel> routes) {
    final unaffected = routes.where((r) => !r.isAffectedByReport).toList();
    if (unaffected.isNotEmpty) {
      return unaffected.firstWhere((r) => r.isPrimary, orElse: () => unaffected.first);
    }
    return routes.firstWhere((r) => r.isPrimary, orElse: () => routes.first);
  }

  void _autoSelectDriver() {
    if (state.originLatLng == null) return;
    final driverRepo = _ref.read(driverRepositoryProvider);
    final nearest = driverRepo.getNearestTo(state.originLatLng!);
    if (nearest != null) {
      state = state.copyWith(selectedDriver: nearest);
    }
  }

  void selectRoute(String routeId) {
    state = state.copyWith(selectedRouteId: routeId);
  }

  void selectDriver(Driver driver) {
    state = state.copyWith(selectedDriver: driver);
  }

  void confirmBooking() {
    state = state.copyWith(status: RideStatus.booked);
  }

  void reset() {
    state = const RideState();
  }

  double? get estimatedPrice {
    final route = state.selectedRoute;
    final driver = state.selectedDriver;
    if (route == null || driver == null) return null;
    return (route.distanceKm * driver.pricePerKm).roundToDouble();
  }

  /// Haversine distance between origin and nearest driver (km).
  double? get distanceToDriver {
    final origin = state.originLatLng;
    final driver = state.selectedDriver;
    if (origin == null || driver == null) return null;
    return haversineDistance(
      origin.latitude,
      origin.longitude,
      driver.position.latitude,
      driver.position.longitude,
    );
  }
}

final rideProvider = StateNotifierProvider<RideNotifier, RideState>(
  (ref) => RideNotifier(ref),
);
