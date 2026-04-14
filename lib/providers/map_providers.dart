import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/theme/app_theme.dart';
import '../models/road_report.dart';
import 'reports_provider.dart';
import 'repository_providers.dart';
import 'ride_provider.dart';

// ── Tab / mode ────────────────────────────────────────────────────────────────

enum MapMode { ride, trips, reports, services }

final mapModeProvider = StateProvider<MapMode>((ref) => MapMode.ride);

// ── Driver markers ─────────────────────────────────────────────────────────────

final driverMarkersProvider = Provider<Set<Marker>>((ref) {
  final drivers = ref.watch(
    driverRepositoryProvider.select((repo) => repo.getAvailable()),
  );
  final selectedDriver = ref.watch(
    rideProvider.select((s) => s.selectedDriver),
  );

  return drivers.map((d) {
    final isSelected = d.id == selectedDriver?.id;
    return Marker(
      markerId: MarkerId('driver_${d.id}'),
      position: d.position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        isSelected ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueCyan,
      ),
      infoWindow: InfoWindow(
        title: d.name,
        snippet: '${d.vehicleModel} · ⭐ ${d.rating}',
      ),
    );
  }).toSet();
});

// ── Report markers ────────────────────────────────────────────────────────────

final reportMarkersProvider = Provider<Set<Marker>>((ref) {
  final reports = ref.watch(activeReportsProvider);
  return reports.map((r) => _reportMarker(r)).toSet();
});

Marker _reportMarker(RoadReport r) {
  final hue = switch (r.type) {
    ReportType.traffic => BitmapDescriptor.hueOrange,
    ReportType.checkpoint => BitmapDescriptor.hueBlue,
    ReportType.roadClosed => BitmapDescriptor.hueRed,
  };
  return Marker(
    markerId: MarkerId('report_${r.id}'),
    position: r.position,
    icon: BitmapDescriptor.defaultMarkerWithHue(hue),
    infoWindow: InfoWindow(
      title: '${r.type.emoji} ${r.type.label}',
      snippet: r.description,
    ),
  );
}

// ── Parking + gas markers ─────────────────────────────────────────────────────

final parkingMarkersProvider = Provider<Set<Marker>>((ref) {
  final spots = ref.watch(
    parkingRepositoryProvider.select((repo) => repo.getAll()),
  );
  return spots.map((s) {
    return Marker(
      markerId: MarkerId('parking_${s.id}'),
      position: s.position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(
        title: 'P  ${s.name}',
        snippet: '${s.availabilityLabel} · ₪${s.pricePerHour}/h',
      ),
    );
  }).toSet();
});

final gasMarkersProvider = Provider<Set<Marker>>((ref) {
  final stations = ref.watch(
    gasRepositoryProvider.select((repo) => repo.getAll()),
  );
  return stations.map((s) {
    return Marker(
      markerId: MarkerId('gas_${s.id}'),
      position: s.position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        s.isOpen ? BitmapDescriptor.hueYellow : BitmapDescriptor.hueRose,
      ),
      infoWindow: InfoWindow(
        title: '⛽ ${s.name}',
        snippet: '₪${s.pricePerLiter.toStringAsFixed(2)}/L · ${s.isOpen ? "Open" : "Closed"}',
      ),
    );
  }).toSet();
});

// ── Combined markers (driven by current mode) ─────────────────────────────────

final mapMarkersProvider = Provider<Set<Marker>>((ref) {
  final mode = ref.watch(mapModeProvider);
  switch (mode) {
    case MapMode.ride:
      return ref.watch(driverMarkersProvider);
    case MapMode.trips:
      return {};
    case MapMode.reports:
      return ref.watch(reportMarkersProvider);
    case MapMode.services:
      return {
        ...ref.watch(parkingMarkersProvider),
        ...ref.watch(gasMarkersProvider),
      };
  }
});

// ── Polylines ─────────────────────────────────────────────────────────────────

final mapPolylinesProvider = Provider<Set<Polyline>>((ref) {
  final mode = ref.watch(mapModeProvider);
  if (mode != MapMode.ride) return {};

  final routes = ref.watch(rideProvider.select((s) => s.routes));
  final selectedId = ref.watch(rideProvider.select((s) => s.selectedRouteId));

  return routes.asMap().entries.map((entry) {
    final route = entry.value;
    final isSelected = route.id == selectedId;
    Color color;
    int width;
    if (isSelected) {
      color = route.isAffectedByReport ? AppColors.warning : AppColors.primary;
      width = 6;
    } else {
      color = AppColors.textHint.withValues(alpha: 0.6);
      width = 3;
    }
    return Polyline(
      polylineId: PolylineId(route.id),
      points: route.points,
      color: color,
      width: width,
      patterns: isSelected ? [] : [PatternItem.dash(12), PatternItem.gap(8)],
    );
  }).toSet();
});
