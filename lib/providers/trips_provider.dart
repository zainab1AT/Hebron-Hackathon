import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trip.dart';
import 'repository_providers.dart';

class TripsNotifier extends StateNotifier<List<Trip>> {
  TripsNotifier(super.state, this._ref);
  final Ref _ref;

  /// Returns the updated [Trip], or throws if the trip is full.
  Trip joinTrip(String tripId, String passengerId) {
    final repo = _ref.read(tripRepositoryProvider);
    final updated = repo.joinTrip(tripId, passengerId);
    state = [
      for (final t in state)
        if (t.id == tripId) updated else t,
    ];
    return updated;
  }
}

final tripsProvider =
    StateNotifierProvider<TripsNotifier, List<Trip>>((ref) {
  final repo = ref.read(tripRepositoryProvider);
  return TripsNotifier(repo.getAll(), ref);
});

/// Derived – trips that still have seats.
final availableTripsProvider = Provider<List<Trip>>((ref) {
  return ref.watch(tripsProvider).where((t) => t.hasSeats).toList();
});
