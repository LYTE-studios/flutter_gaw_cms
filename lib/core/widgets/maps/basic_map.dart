import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BasicMap extends StatefulWidget {
  final Set<Marker>? markers;

  final LatLng? position;

  final LatLng startPosition;

  final bool showCurrentLocation;

  final LatLng? selectedAddressPosition;

  final bool centerOnSelectedAddress;

  final Function(CameraPosition)? onMoveCamera;

  final bool showRoute;

  const BasicMap({
    super.key,
    this.markers,
    this.position,
    required this.startPosition,
    this.showCurrentLocation = false,
    this.selectedAddressPosition,
    this.centerOnSelectedAddress = false,
    this.onMoveCamera,
    this.showRoute = false,
  });

  @override
  State<BasicMap> createState() => _BasicMapState();
}

class _BasicMapState extends State<BasicMap> with ScreenStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Polyline> lines = {};

  late Set<Marker> markers = widget.markers ?? {};

  void setStyle(BuildContext context) {
    // DefaultAssetBundle.of(context)
    //     .loadString(
    //   'lib/assets/styles/map_style.json',
    //   cache: true,
    // )
    //     .then(
    //   (asset) {
    //     _controller.future.then((controller) {
    //       controller.setMapStyle(asset);
    //     });
    //   },
    // );
  }

  @override
  void initState() {
    setStyle(context);
    super.initState();
  }

  @override
  void dispose() {
    _controller.future.then((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.position != null) {
      _controller.future.then((controller) {
        controller.moveCamera(
          CameraUpdate.newLatLng(
            LatLng(
              widget.position!.latitude,
              widget.position!.longitude,
            ),
          ),
        );
      });
    }

    return LoadingSwitcher(
      loading: loading,
      child: GoogleMap(
        onCameraMove: widget.onMoveCamera,
        myLocationEnabled: widget.showCurrentLocation,
        myLocationButtonEnabled: widget.showCurrentLocation,
        markers: markers,
        onMapCreated: (controller) async {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        },
        polylines: lines,
        initialCameraPosition: CameraPosition(
          target: widget.startPosition,
          zoom: 7,
        ),
        compassEnabled: false,
        mapToolbarEnabled: false,
        buildingsEnabled: false,
      ),
    );
  }
}
