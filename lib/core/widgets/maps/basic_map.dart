import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gaw_api/gaw_api.dart';
import 'package:gaw_ui/gaw_ui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BasicMap extends StatefulWidget {
  final Completer<GoogleMapController>? controller;

  final Set<Marker>? markers;

  final LatLng? position;

  final LatLng startPosition;

  final double? initialZoom;

  final bool showCurrentLocation;

  final LatLng? selectedAddressPosition;

  final bool centerOnSelectedAddress;

  final Function(CameraPosition)? onMoveCamera;

  final bool showRoute;

  final bool setInitialMarker;

  const BasicMap({
    super.key,
    this.controller,
    this.markers,
    this.position,
    this.initialZoom,
    required this.startPosition,
    this.showCurrentLocation = false,
    this.selectedAddressPosition,
    this.centerOnSelectedAddress = false,
    this.onMoveCamera,
    this.showRoute = false,
    this.setInitialMarker = true,
  });

  @override
  State<BasicMap> createState() => BasicMapState();
}

class BasicMapState extends State<BasicMap> with ScreenStateMixin {
  late final Completer<GoogleMapController> _controller =
      widget.controller ?? Completer<GoogleMapController>();

  GoogleMapController? mapController;

  Set<Polyline> lines = {};

  late Set<Marker> markers = widget.markers ?? getInitialMarkers();

  bool isCompleted = false;

  String? mapTheme;

  Set<Marker> getInitialMarkers() {
    Set<Marker> markers = {};

    if (widget.setInitialMarker) {
      markers.add(
        Marker(
          markerId: const MarkerId('Marker'),
          position: widget.startPosition,
        ),
      );
      setMarker(widget.startPosition);
    }

    return markers;
  }

  void setMarker(LatLng position) {
    setState(
      () {
        markers = {
          Marker(
            markerId: const MarkerId('Marker'),
            position: position,
          ),
        };
      },
    );
  }

  void loadTheme() {
    DefaultAssetBundle.of(context)
        .loadString(
      'lib/assets/styles/map_style.json',
      cache: true,
    )
        .then((asset) {
      mapTheme = asset;
    });
  }

  void updateMap(Address address) {
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(address.latitude!, address.longitude!),
        15,
      ),
    );
    setMarker(
      LatLng(
        address.latitude!,
        address.longitude!,
      ),
    );
  }

  @override
  void initState() {
    loading = true;
    Future(() {
      loadTheme();
    });

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
    return GoogleMap(
      onCameraMove: widget.onMoveCamera,
      myLocationEnabled: widget.showCurrentLocation,
      myLocationButtonEnabled: widget.showCurrentLocation,
      markers: markers,
      onMapCreated: (controller) async {
        setState(() {
          mapController = controller;
        });
        await controller.setMapStyle(mapTheme);
      },
      polylines: lines,
      initialCameraPosition: CameraPosition(
        target: widget.startPosition,
        zoom: widget.initialZoom ?? 7,
      ),
      compassEnabled: false,
      mapToolbarEnabled: false,
      buildingsEnabled: false,
    );
  }
}
