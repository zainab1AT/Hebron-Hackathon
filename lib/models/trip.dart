import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {
  final String id;
  final String driverName;
  final String origin;
  final String destination;
  final LatLng originLatLng;
  final LatLng destinationLatLng;
  final int totalSeats;
  final int availableSeats;
  final double pricePerSeat;
  final DateTime departureTime;
  final List<String> passengerIds;

  const Trip({
    required this.id,
    required this.driverName,
    required this.origin,
    required this.destination,
    required this.originLatLng,
    required this.destinationLatLng,
    required this.totalSeats,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.departureTime,
    this.passengerIds = const [],
  });

  bool get hasSeats => availableSeats > 0;
  bool get isFull => availableSeats == 0;
  double get occupancyRate => (totalSeats - availableSeats) / totalSeats;

  Trip copyWith({
    String? id,
    String? driverName,
    String? origin,
    String? destination,
    LatLng? originLatLng,
    LatLng? destinationLatLng,
    int? totalSeats,
    int? availableSeats,
    double? pricePerSeat,
    DateTime? departureTime,
    List<String>? passengerIds,
  }) =>
      Trip(
        id: id ?? this.id,
        driverName: driverName ?? this.driverName,
        origin: origin ?? this.origin,
        destination: destination ?? this.destination,
        originLatLng: originLatLng ?? this.originLatLng,
        destinationLatLng: destinationLatLng ?? this.destinationLatLng,
        totalSeats: totalSeats ?? this.totalSeats,
        availableSeats: availableSeats ?? this.availableSeats,
        pricePerSeat: pricePerSeat ?? this.pricePerSeat,
        departureTime: departureTime ?? this.departureTime,
        passengerIds: passengerIds ?? this.passengerIds,
      );
}
