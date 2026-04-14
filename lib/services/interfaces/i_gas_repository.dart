import '../../models/gas_station.dart';

abstract class IGasRepository {
  List<GasStation> getAll();
}
