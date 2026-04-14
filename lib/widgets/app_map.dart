import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../core/constants.dart';
import '../providers/map_providers.dart';

/// The full-screen Google Map widget.
/// Only rebuilds when markers or polylines change (select-optimised).
class AppMap extends ConsumerStatefulWidget {
  const AppMap({super.key});

  @override
  ConsumerState<AppMap> createState() => AppMapState();
}

class AppMapState extends ConsumerState<AppMap> {
  GoogleMapController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> animateTo(LatLng target, {double zoom = 15}) async {
    await _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = ref.watch(mapMarkersProvider);
    final polylines = ref.watch(mapPolylinesProvider);

    return GoogleMap(
      initialCameraPosition: AppConstants.initialCamera,
      markers: markers,
      polylines: polylines,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      buildingsEnabled: true,
      style: AppConstants.mapStyle,
      onMapCreated: (controller) {
        _controller = controller;
      },
    );
  }
}
