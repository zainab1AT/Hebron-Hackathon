import 'package:google_maps_flutter/google_maps_flutter.dart';

class GasStation {
  final String id;
  final String name;
  final String brand;
  final LatLng position;
  final double pricePerLiter;
  final bool isOpen;
  final List<String> fuelTypes;

  const GasStation({
    required this.id,
    required this.name,
    required this.brand,
    required this.position,
    required this.pricePerLiter,
    required this.isOpen,
    required this.fuelTypes,
  });

  GasStation copyWith({
    String? id,
    String? name,
    String? brand,
    LatLng? position,
    double? pricePerLiter,
    bool? isOpen,
    List<String>? fuelTypes,
  }) =>
      GasStation(
        id: id ?? this.id,
        name: name ?? this.name,
        brand: brand ?? this.brand,
        position: position ?? this.position,
        pricePerLiter: pricePerLiter ?? this.pricePerLiter,
        isOpen: isOpen ?? this.isOpen,
        fuelTypes: fuelTypes ?? this.fuelTypes,
      );
}
