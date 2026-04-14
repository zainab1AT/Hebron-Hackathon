import 'package:google_maps_flutter/google_maps_flutter.dart';

class Driver {
  final String id;
  final String name;
  final double rating;
  final int totalRatings;
  final String vehicleModel;
  final String vehicleColor;
  final String licensePlate;
  final LatLng position;
  final bool isAvailable;
  final double pricePerKm;

  const Driver({
    required this.id,
    required this.name,
    required this.rating,
    required this.totalRatings,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.licensePlate,
    required this.position,
    required this.isAvailable,
    required this.pricePerKm,
  });

  Driver copyWith({
    String? id,
    String? name,
    double? rating,
    int? totalRatings,
    String? vehicleModel,
    String? vehicleColor,
    String? licensePlate,
    LatLng? position,
    bool? isAvailable,
    double? pricePerKm,
  }) =>
      Driver(
        id: id ?? this.id,
        name: name ?? this.name,
        rating: rating ?? this.rating,
        totalRatings: totalRatings ?? this.totalRatings,
        vehicleModel: vehicleModel ?? this.vehicleModel,
        vehicleColor: vehicleColor ?? this.vehicleColor,
        licensePlate: licensePlate ?? this.licensePlate,
        position: position ?? this.position,
        isAvailable: isAvailable ?? this.isAvailable,
        pricePerKm: pricePerKm ?? this.pricePerKm,
      );

  /// Returns initials for avatar display.
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}
