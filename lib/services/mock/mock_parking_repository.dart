import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/parking_spot.dart';
import '../interfaces/i_parking_repository.dart';

class MockParkingRepository implements IParkingRepository {
  static final List<ParkingSpot> _spots = [
    const ParkingSpot(
      id: 'p1',
      name: 'City Centre Parking',
      position: LatLng(31.5298, 35.0975),
      totalSpots: 50,
      availableSpots: 20,
      pricePerHour: 3.0,
      isCovered: false,
    ),
    const ParkingSpot(
      id: 'p2',
      name: 'Hebron Mall Parking',
      position: LatLng(31.5442, 35.0785),
      totalSpots: 200,
      availableSpots: 45,
      pricePerHour: 2.0,
      isCovered: true,
    ),
    const ParkingSpot(
      id: 'p3',
      name: 'Old City Parking',
      position: LatLng(31.5265, 35.1085),
      totalSpots: 30,
      availableSpots: 5,
      pricePerHour: 4.0,
      isCovered: false,
    ),
    const ParkingSpot(
      id: 'p4',
      name: 'University Parking',
      position: LatLng(31.5378, 35.0840),
      totalSpots: 80,
      availableSpots: 60,
      pricePerHour: 1.0,
      isCovered: false,
    ),
    const ParkingSpot(
      id: 'p5',
      name: 'Al-Ahli Hospital Parking',
      position: LatLng(31.5408, 35.0898),
      totalSpots: 60,
      availableSpots: 10,
      pricePerHour: 2.5,
      isCovered: true,
    ),
    const ParkingSpot(
      id: 'p6',
      name: 'Industrial Zone Parking',
      position: LatLng(31.5148, 35.0705),
      totalSpots: 100,
      availableSpots: 75,
      pricePerHour: 0.0,
      isCovered: false,
    ),
  ];

  @override
  List<ParkingSpot> getAll() => List.unmodifiable(_spots);
}
