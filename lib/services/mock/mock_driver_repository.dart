import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/utils/haversine.dart';
import '../../models/driver.dart';
import '../interfaces/i_driver_repository.dart';

class MockDriverRepository implements IDriverRepository {
  // 10 drivers spread around Hebron, Palestine
  static final List<Driver> _drivers = [
    const Driver(
      id: 'd1',
      name: 'Ahmad Khalil',
      rating: 4.9,
      totalRatings: 312,
      vehicleModel: 'Toyota Corolla',
      vehicleColor: 'White',
      licensePlate: '12-345-PL',
      position: LatLng(31.5326, 35.0990),
      isAvailable: true,
      pricePerKm: 3.5,
    ),
    const Driver(
      id: 'd2',
      name: 'Mohammed Natsheh',
      rating: 4.7,
      totalRatings: 198,
      vehicleModel: 'Hyundai Tucson',
      vehicleColor: 'Silver',
      licensePlate: '67-891-PL',
      position: LatLng(31.5280, 35.1050),
      isAvailable: true,
      pricePerKm: 4.0,
    ),
    const Driver(
      id: 'd3',
      name: 'Ibrahim Jabari',
      rating: 4.8,
      totalRatings: 427,
      vehicleModel: 'Kia Sportage',
      vehicleColor: 'Black',
      licensePlate: '23-456-PL',
      position: LatLng(31.5400, 35.0850),
      isAvailable: true,
      pricePerKm: 3.8,
    ),
    const Driver(
      id: 'd4',
      name: 'Youssef Tamimi',
      rating: 4.6,
      totalRatings: 155,
      vehicleModel: 'Nissan Sunny',
      vehicleColor: 'Blue',
      licensePlate: '78-012-PL',
      position: LatLng(31.5450, 35.0780),
      isAvailable: false,
      pricePerKm: 3.2,
    ),
    const Driver(
      id: 'd5',
      name: 'Kareem Hroub',
      rating: 4.5,
      totalRatings: 89,
      vehicleModel: 'Volkswagen Passat',
      vehicleColor: 'Grey',
      licensePlate: '34-567-PL',
      position: LatLng(31.5200, 35.0900),
      isAvailable: true,
      pricePerKm: 4.2,
    ),
    const Driver(
      id: 'd6',
      name: 'Walid Abu Sneina',
      rating: 4.9,
      totalRatings: 501,
      vehicleModel: 'Mercedes C-Class',
      vehicleColor: 'Black',
      licensePlate: '89-123-PL',
      position: LatLng(31.5350, 35.1100),
      isAvailable: true,
      pricePerKm: 5.5,
    ),
    const Driver(
      id: 'd7',
      name: 'Samir Qawasmeh',
      rating: 4.3,
      totalRatings: 74,
      vehicleModel: 'Skoda Octavia',
      vehicleColor: 'Red',
      licensePlate: '45-678-PL',
      position: LatLng(31.5480, 35.0920),
      isAvailable: true,
      pricePerKm: 3.6,
    ),
    const Driver(
      id: 'd8',
      name: 'Fadi Dweik',
      rating: 4.7,
      totalRatings: 263,
      vehicleModel: 'Honda Civic',
      vehicleColor: 'White',
      licensePlate: '90-234-PL',
      position: LatLng(31.5150, 35.0800),
      isAvailable: false,
      pricePerKm: 3.4,
    ),
    const Driver(
      id: 'd9',
      name: 'Nasser Rajabi',
      rating: 4.8,
      totalRatings: 188,
      vehicleModel: 'Ford Focus',
      vehicleColor: 'Dark Blue',
      licensePlate: '56-789-PL',
      position: LatLng(31.5310, 35.0750),
      isAvailable: true,
      pricePerKm: 3.7,
    ),
    const Driver(
      id: 'd10',
      name: 'Tariq Azza',
      rating: 4.4,
      totalRatings: 112,
      vehicleModel: 'Peugeot 301',
      vehicleColor: 'Silver',
      licensePlate: '12-890-PL',
      position: LatLng(31.5420, 35.1020),
      isAvailable: true,
      pricePerKm: 3.3,
    ),
  ];

  @override
  List<Driver> getAll() => List.unmodifiable(_drivers);

  @override
  List<Driver> getAvailable() =>
      _drivers.where((d) => d.isAvailable).toList(growable: false);

  @override
  Driver? getNearestTo(LatLng position) {
    final available = getAvailable();
    if (available.isEmpty) return null;
    available.sort((a, b) {
      final da = haversineDistance(
          position.latitude, position.longitude,
          a.position.latitude, a.position.longitude);
      final db = haversineDistance(
          position.latitude, position.longitude,
          b.position.latitude, b.position.longitude);
      return da.compareTo(db);
    });
    return available.first;
  }
}
