import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../models/gas_station.dart';
import '../models/parking_spot.dart';
import '../providers/repository_providers.dart';
import '../widgets/service_detail_sheet.dart';

class ServicesTab extends ConsumerStatefulWidget {
  const ServicesTab({super.key});

  @override
  ConsumerState<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends ConsumerState<ServicesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text('Services',
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(icon: Icon(Icons.local_parking_rounded), text: 'Parking'),
            Tab(icon: Icon(Icons.local_gas_station_rounded), text: 'Gas'),
          ],
        ),
        SizedBox(
          height: 280,
          child: TabBarView(
            controller: _tabController,
            children: [
              _ParkingList(
                  onTap: (spot) => _showParking(context, spot)),
              _GasList(
                  onTap: (station) => _showGas(context, station)),
            ],
          ),
        ),
      ],
    );
  }

  void _showParking(BuildContext context, ParkingSpot spot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ParkingDetailSheet(spot: spot),
    );
  }

  void _showGas(BuildContext context, GasStation station) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GasDetailSheet(station: station),
    );
  }
}

class _ParkingList extends ConsumerWidget {
  final void Function(ParkingSpot) onTap;
  const _ParkingList({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spots = ref.watch(
        parkingRepositoryProvider.select((repo) => repo.getAll()));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: spots.length,
      itemBuilder: (_, i) => _ParkingTile(spot: spots[i], onTap: onTap),
    );
  }
}

class _ParkingTile extends StatelessWidget {
  final ParkingSpot spot;
  final void Function(ParkingSpot) onTap;
  const _ParkingTile({required this.spot, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = spot.availableSpots == 0
        ? AppColors.error
        : spot.availableSpots <= 5
            ? AppColors.warning
            : AppColors.primary;
    return ListTile(
      onTap: () => onTap(spot),
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.15),
        ),
        child: Center(
          child: Text('P',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 16)),
        ),
      ),
      title: Text(spot.name,
          style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(
        spot.isCovered ? 'Covered · ${spot.availabilityLabel}' :
                         'Open · ${spot.availabilityLabel}',
        style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 12),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            spot.pricePerHour == 0
                ? 'Free'
                : '₪${spot.pricePerHour.toStringAsFixed(1)}/h',
            style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textHint, size: 16),
        ],
      ),
    );
  }
}

class _GasList extends ConsumerWidget {
  final void Function(GasStation) onTap;
  const _GasList({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(
        gasRepositoryProvider.select((repo) => repo.getAll()));
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: stations.length,
      itemBuilder: (_, i) => _GasTile(station: stations[i], onTap: onTap),
    );
  }
}

class _GasTile extends StatelessWidget {
  final GasStation station;
  final void Function(GasStation) onTap;
  const _GasTile({required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(station),
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.warning.withValues(alpha: 0.15),
        ),
        child: const Center(
          child: Text('⛽', style: TextStyle(fontSize: 18)),
        ),
      ),
      title: Text(station.name,
          style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(station.fuelTypes.join(' · '),
          style: const TextStyle(
              color: AppColors.textSecondary, fontSize: 12)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '₪${station.pricePerLiter.toStringAsFixed(2)}/L',
            style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: station.isOpen
                  ? AppColors.primary.withValues(alpha: 0.12)
                  : AppColors.error.withValues(alpha: 0.12),
            ),
            child: Text(
              station.isOpen ? 'Open' : 'Closed',
              style: TextStyle(
                  color: station.isOpen ? AppColors.primary : AppColors.error,
                  fontSize: 10,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
