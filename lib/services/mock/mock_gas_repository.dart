import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/gas_station.dart';
import '../interfaces/i_gas_repository.dart';

class MockGasRepository implements IGasRepository {
  static final List<GasStation> _stations = [
    const GasStation(
      id: 'g1',
      name: 'Shell – City Centre',
      brand: 'Shell',
      position: LatLng(31.5315, 35.0965),
      pricePerLiter: 7.20,
      isOpen: true,
      fuelTypes: ['95', '98', 'Diesel'],
    ),
    const GasStation(
      id: 'g2',
      name: 'Total – Mall Road',
      brand: 'TotalEnergies',
      position: LatLng(31.5460, 35.0770),
      pricePerLiter: 7.15,
      isOpen: true,
      fuelTypes: ['95', 'Diesel'],
    ),
    const GasStation(
      id: 'g3',
      name: 'Paz – University Road',
      brand: 'Paz',
      position: LatLng(31.5395, 35.0855),
      pricePerLiter: 7.25,
      isOpen: true,
      fuelTypes: ['95', '98', 'Diesel', 'LPG'],
    ),
    const GasStation(
      id: 'g4',
      name: 'Delek – South Hebron',
      brand: 'Delek',
      position: LatLng(31.5190, 35.0880),
      pricePerLiter: 7.10,
      isOpen: false,
      fuelTypes: ['95', 'Diesel'],
    ),
    const GasStation(
      id: 'g5',
      name: 'Wolf – North District',
      brand: 'Wolf',
      position: LatLng(31.5510, 35.0950),
      pricePerLiter: 7.30,
      isOpen: true,
      fuelTypes: ['95', '98'],
    ),
    const GasStation(
      id: 'g6',
      name: 'Dor Alon – East',
      brand: 'Dor Alon',
      position: LatLng(31.5340, 35.1080),
      pricePerLiter: 7.18,
      isOpen: true,
      fuelTypes: ['95', 'Diesel', 'LPG'],
    ),
  ];

  @override
  List<GasStation> getAll() => List.unmodifiable(_stations);
}
