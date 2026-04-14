import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/trip.dart';
import '../interfaces/i_trip_repository.dart';

class MockTripRepository implements ITripRepository {
  final List<Trip> _trips = [
    Trip(
      id: 't1',
      driverName: 'Ahmad Khalil',
      origin: 'Hebron Mall',
      destination: 'Bethlehem',
      originLatLng: const LatLng(31.5445, 35.0791),
      destinationLatLng: const LatLng(31.7054, 35.2024),
      totalSeats: 4,
      availableSeats: 2,
      pricePerSeat: 25.0,
      departureTime: DateTime.now().add(const Duration(minutes: 30)),
    ),
    Trip(
      id: 't2',
      driverName: 'Mohammed Natsheh',
      origin: 'City Centre',
      destination: 'Ramallah',
      originLatLng: const LatLng(31.5300, 35.0980),
      destinationLatLng: const LatLng(31.9038, 35.2034),
      totalSeats: 3,
      availableSeats: 1,
      pricePerSeat: 40.0,
      departureTime: DateTime.now().add(const Duration(hours: 1)),
    ),
    Trip(
      id: 't3',
      driverName: 'Ibrahim Jabari',
      origin: 'Hebron University',
      destination: 'Hebron Mall',
      originLatLng: const LatLng(31.5374, 35.0837),
      destinationLatLng: const LatLng(31.5445, 35.0791),
      totalSeats: 4,
      availableSeats: 3,
      pricePerSeat: 8.0,
      departureTime: DateTime.now().add(const Duration(minutes: 15)),
    ),
    Trip(
      id: 't4',
      driverName: 'Walid Abu Sneina',
      origin: 'Old City',
      destination: 'Industrial Zone',
      originLatLng: const LatLng(31.5243, 35.1098),
      destinationLatLng: const LatLng(31.5145, 35.0702),
      totalSeats: 3,
      availableSeats: 0,
      pricePerSeat: 10.0,
      departureTime: DateTime.now().add(const Duration(minutes: 5)),
    ),
    Trip(
      id: 't5',
      driverName: 'Kareem Hroub',
      origin: 'Dura',
      destination: 'City Centre',
      originLatLng: const LatLng(31.4987, 35.0501),
      destinationLatLng: const LatLng(31.5300, 35.0980),
      totalSeats: 4,
      availableSeats: 4,
      pricePerSeat: 15.0,
      departureTime: DateTime.now().add(const Duration(hours: 2)),
    ),
    Trip(
      id: 't6',
      driverName: 'Samir Qawasmeh',
      origin: 'Halhul',
      destination: 'Old City',
      originLatLng: const LatLng(31.5840, 35.0975),
      destinationLatLng: const LatLng(31.5243, 35.1098),
      totalSeats: 4,
      availableSeats: 2,
      pricePerSeat: 12.0,
      departureTime: DateTime.now().add(const Duration(minutes: 45)),
    ),
    Trip(
      id: 't7',
      driverName: 'Nasser Rajabi',
      origin: 'Al-Ahli Hospital',
      destination: 'Hebron University',
      originLatLng: const LatLng(31.5412, 35.0901),
      destinationLatLng: const LatLng(31.5374, 35.0837),
      totalSeats: 3,
      availableSeats: 1,
      pricePerSeat: 6.0,
      departureTime: DateTime.now().add(const Duration(minutes: 20)),
    ),
    Trip(
      id: 't8',
      driverName: 'Tariq Azza',
      origin: 'Industrial Zone',
      destination: 'Hebron Mall',
      originLatLng: const LatLng(31.5145, 35.0702),
      destinationLatLng: const LatLng(31.5445, 35.0791),
      totalSeats: 4,
      availableSeats: 3,
      pricePerSeat: 11.0,
      departureTime: DateTime.now().add(const Duration(hours: 1, minutes: 30)),
    ),
  ];

  @override
  List<Trip> getAll() => List.unmodifiable(_trips);

  @override
  Trip joinTrip(String tripId, String passengerId) {
    final idx = _trips.indexWhere((t) => t.id == tripId);
    if (idx == -1) throw StateError('Trip $tripId not found');
    final trip = _trips[idx];
    if (trip.isFull) throw StateError('Trip $tripId is full');
    final updated = trip.copyWith(
      availableSeats: trip.availableSeats - 1,
      passengerIds: [...trip.passengerIds, passengerId],
    );
    _trips[idx] = updated;
    return updated;
  }
}
