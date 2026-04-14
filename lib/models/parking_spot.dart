import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingSpot {
  final String id;
  final String name;
  final LatLng position;
  final int totalSpots;
  final int availableSpots;
  final double pricePerHour;
  final bool isCovered;

  const ParkingSpot({
    required this.id,
    required this.name,
    required this.position,
    required this.totalSpots,
    required this.availableSpots,
    required this.pricePerHour,
    required this.isCovered,
  });

  bool get hasSpots => availableSpots > 0;
  double get occupancyPercent =>
      (totalSpots - availableSpots) / totalSpots * 100;

  String get availabilityLabel {
    if (availableSpots == 0) return 'Full';
    if (availableSpots <= 5) return 'Almost full ($availableSpots left)';
    return '$availableSpots spots';
  }

  ParkingSpot copyWith({
    String? id,
    String? name,
    LatLng? position,
    int? totalSpots,
    int? availableSpots,
    double? pricePerHour,
    bool? isCovered,
  }) =>
      ParkingSpot(
        id: id ?? this.id,
        name: name ?? this.name,
        position: position ?? this.position,
        totalSpots: totalSpots ?? this.totalSpots,
        availableSpots: availableSpots ?? this.availableSpots,
        pricePerHour: pricePerHour ?? this.pricePerHour,
        isCovered: isCovered ?? this.isCovered,
      );
}
