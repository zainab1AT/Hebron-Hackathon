import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/driver.dart';

abstract class IDriverRepository {
  /// Returns all drivers in the mock dataset.
  List<Driver> getAll();

  /// Returns available drivers only.
  List<Driver> getAvailable();

  /// Returns the nearest available driver to [position] using
  /// Haversine distance.  Returns null if no drivers are available.
  Driver? getNearestTo(LatLng position);
}
