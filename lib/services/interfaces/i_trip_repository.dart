import '../../models/trip.dart';

abstract class ITripRepository {
  List<Trip> getAll();

  /// Reduces [tripId]'s available seats by 1 and adds [passengerId].
  /// Throws [StateError] if the trip is full or not found.
  Trip joinTrip(String tripId, String passengerId);
}
