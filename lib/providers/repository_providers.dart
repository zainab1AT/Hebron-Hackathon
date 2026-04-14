import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/interfaces/i_driver_repository.dart';
import '../services/interfaces/i_gas_repository.dart';
import '../services/interfaces/i_parking_repository.dart';
import '../services/interfaces/i_report_repository.dart';
import '../services/interfaces/i_route_repository.dart';
import '../services/interfaces/i_trip_repository.dart';
import '../services/mock/mock_driver_repository.dart';
import '../services/mock/mock_gas_repository.dart';
import '../services/mock/mock_parking_repository.dart';
import '../services/mock/mock_report_repository.dart';
import '../services/mock/mock_route_repository.dart';
import '../services/mock/mock_trip_repository.dart';

/// Wire mock implementations here.
/// To swap for real APIs: replace MockXxxRepository() with RealXxxRepository().

final driverRepositoryProvider = Provider<IDriverRepository>(
  (_) => MockDriverRepository(),
);

final tripRepositoryProvider = Provider<ITripRepository>(
  (_) => MockTripRepository(),
);

final reportRepositoryProvider = Provider<IReportRepository>(
  (_) => MockReportRepository(),
);

final routeRepositoryProvider = Provider<IRouteRepository>(
  (_) => MockRouteRepository(),
);

final parkingRepositoryProvider = Provider<IParkingRepository>(
  (_) => MockParkingRepository(),
);

final gasRepositoryProvider = Provider<IGasRepository>(
  (_) => MockGasRepository(),
);
