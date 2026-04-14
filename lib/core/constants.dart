import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConstants {
  AppConstants._();

  // Hebron, Palestine – city centre
  static const LatLng hebronCenter = LatLng(31.5300, 35.0980);

  static const CameraPosition initialCamera = CameraPosition(
    target: hebronCenter,
    zoom: 14.0,
  );

  // Map style – clean light theme, good for daylight readability
  static const String mapStyle = '''[
    {"featureType":"poi","elementType":"labels","stylers":[{"visibility":"off"}]},
    {"featureType":"transit","elementType":"labels","stylers":[{"visibility":"simplified"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9e4f0"}]},
    {"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#ffffff"}]},
    {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#d6d6d6"}]},
    {"featureType":"landscape.man_made","elementType":"geometry","stylers":[{"color":"#f0f0f0"}]},
    {"featureType":"landscape.natural","elementType":"geometry.fill","stylers":[{"color":"#e8f0e4"}]}
  ]''';

  // Seat counts
  static const int maxSeatsPerTrip = 4;

  // Report voting threshold to appear on map
  static const int reportVoteThreshold = 3;

  // Haversine earth radius (km)
  static const double earthRadiusKm = 6371.0;

  // Distance (km) within which a report is considered to affect a route
  static const double reportRouteAffectRadius = 0.3;
}
