import '../../models/parking_spot.dart';

abstract class IParkingRepository {
  List<ParkingSpot> getAll();
}
