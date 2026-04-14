import 'package:flutter_test/flutter_test.dart';
import 'package:mobility_mvp/services/mock/mock_trip_repository.dart';

void main() {
  group('Trip seat reduction', () {
    late MockTripRepository repo;

    setUp(() => repo = MockTripRepository());

    test('joining a trip reduces available seats by 1', () {
      // t3 has 3 available seats
      final before = repo.getAll().firstWhere((t) => t.id == 't3');
      expect(before.availableSeats, 3);

      final updated = repo.joinTrip('t3', 'passenger_1');
      expect(updated.availableSeats, 2);
    });

    test('joining adds passenger id to the trip', () {
      const passengerId = 'passenger_42';
      final updated = repo.joinTrip('t3', passengerId);
      expect(updated.passengerIds, contains(passengerId));
    });

    test('joining a full trip throws StateError', () {
      // t4 has 0 available seats
      expect(
        () => repo.joinTrip('t4', 'passenger_x'),
        throwsA(isA<StateError>()),
      );
    });

    test('joining a non-existent trip throws StateError', () {
      expect(
        () => repo.joinTrip('t_nonexistent', 'passenger_x'),
        throwsA(isA<StateError>()),
      );
    });

    test('trip becomes full when last seat is taken', () {
      // t7 has 1 available seat
      final before = repo.getAll().firstWhere((t) => t.id == 't7');
      expect(before.availableSeats, 1);
      expect(before.isFull, isFalse);

      final updated = repo.joinTrip('t7', 'last_passenger');
      expect(updated.availableSeats, 0);
      expect(updated.isFull, isTrue);
      expect(updated.hasSeats, isFalse);
    });

    test('multiple passengers can join the same trip up to capacity', () {
      // t5 has 4 available seats
      repo.joinTrip('t5', 'p1');
      repo.joinTrip('t5', 'p2');
      repo.joinTrip('t5', 'p3');
      final last = repo.joinTrip('t5', 'p4');
      expect(last.availableSeats, 0);
      expect(last.isFull, isTrue);
      expect(() => repo.joinTrip('t5', 'p5'), throwsA(isA<StateError>()));
    });
  });
}
